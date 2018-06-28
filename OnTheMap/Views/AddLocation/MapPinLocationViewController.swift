//
//  MapPinLocationViewController.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 27/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation



class MapPinLocationViewController: GenericViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonSend: UIButton!
    let studentService = StudentService()
    var studentInformation: StudentInformation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        if let studentLocation = studentInformation {
            showLocations(student: studentLocation)
        }
    }
    
    @IBAction func send(_ sender: Any) {
        if let studentLocation = studentInformation {
            loader.startAnimation(self)
            //if studentLocation.locationID == nil {
                // POST
                studentService.postStudentLocation(student: studentLocation) { result in
                    switch result {
                    case .Success(let data):
                        print(data)
                        DispatchQueue.main.async(execute: { () -> Void in
                           self.loader.stopAnimation()
                            self.handleSyncLocationResponse(error: nil)
                        })
                    case .Failure(let error):
                        var errorMessage = ""
                        if let loginError = error as? ServiceError {
                            errorMessage = loginError.error
                        } else {
                            errorMessage = error.localizedDescription
                        }
                        self.showAlert(errorMessage)
                    }
                }
        }
    }
    
    private func showLocations(student: StudentInformation) {
            if let firstName = student.firstName, let lastName = student.lastName, let latitude = student.latitude, let longitude = student.longitude {
                let annotation = MKPointAnnotation()
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotation.title = firstName + " " + lastName
                annotation.subtitle = student.mediaURL
                self.mapView.addAnnotation(annotation)
                mapView.showAnnotations(mapView.annotations, animated: true)
            }
    }
    
    private func extractCoordinate(location: StudentInformation) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let lon = location.longitude {
            return CLLocationCoordinate2DMake(CLLocationDegrees(lat), CLLocationDegrees(lon))
        }
        return nil
    }
    
    private func handleSyncLocationResponse(error: NSError?) {
        if let error = error {
            self.showInfo(withTitle: "Error", withMessage: error.localizedDescription)
        } else {
            self.showInfo(withTitle: "Success", withMessage: "Student Location updated!", action: {
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: .reload, object: nil)
            })
        }
    }
}

extension Notification.Name {
    static let reload = Notification.Name("reload")
}
