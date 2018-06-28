//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 23/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: GenericViewController  {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        delegate = self
        super.viewDidLoad()
        mapView.delegate = self
        updateAnnotation() 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdate(notification:)), name: .reload, object: nil)
    }

    @objc func didUpdate(notification: NSNotification) {
        getLocations() {
            self.updateAnnotation()
        }
    }
}

extension MapViewController {
    
    func updateAnnotation() {
        mapView.removeAnnotations(mapView.annotations)
        
        var annotations = [MKPointAnnotation]()
        
        for student in UdacityUtils.shared.getStudents() {
            if let firstName = student.firstName, let lastName = student.lastName, let latitude = student.latitude, let longitude = student.longitude {
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotation.title = firstName + " " + lastName
                annotation.subtitle = student.mediaURL
                annotations.append(annotation)
            }
        }
        self.mapView.addAnnotations(annotations)
    }
   
}

extension MapViewController:GenericViewDelegate {
    func didUpdate() {
        updateAnnotation()
    }
}

