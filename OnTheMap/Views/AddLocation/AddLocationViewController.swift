//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Lucas César  Nogueira Fonseca on 27/06/2018.
//  Copyright © 2018 Lucas César  Nogueira Fonseca. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationViewController: GenericViewController {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldLocation: UITextField!
    @IBOutlet weak var textFieldLink: UITextField!
    @IBOutlet weak var buttonFindLocation: UIButton!
    
    lazy var geocoder = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    private func setUpNavBar(){
        
        textFieldName.delegate = self
        textFieldLink.delegate = self
        textFieldLocation.delegate = self
        //For title in navigation bar
        self.navigationItem.title = "Add Location"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "CANCEL"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    // MARK: - Actions
    
    @IBAction func findLocation(_ sender: Any) {
        
        let location = textFieldLocation.text!
        let link = textFieldLink.text!
        
        if location.isEmpty || link.isEmpty {
            showInfo(withMessage: "All fields are required.")
            return
        }
        guard let url = URL(string: link), UIApplication.shared.canOpenURL(url) else {
            showInfo(withMessage: "Please provide a valid link.")
            return
        }
        geocode(location: location)
    }
    
    // MARK: - Helpers
    
    private func geocode(location: String) {
        enableControllers(false)
        loader.startAnimation(self)
        geocoder.geocodeAddressString(location) { (placemarkers, error) in
            
            self.enableControllers(true)
            self.performUIUpdatesOnMain {
                self.loader.stopAnimation()
            }
            
            if let error = error {
                self.showInfo(withTitle: "Error", withMessage: "Unable to Forward Geocode Address (\(error))")
            } else {
                var location: CLLocation?
                
                if let placemarks = placemarkers, placemarks.count > 0 {
                    location = placemarks.first?.location
                }
                
                if let location = location {
                    self.syncStudentLocation(location.coordinate)
                } else {
                    self.showInfo(withMessage: "No Matching Location Found")
                }
            }
        }
    }
    
    private func syncStudentLocation(_ coordinate: CLLocationCoordinate2D) {
        self.enableControllers(true)
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "MapPinLocationViewController") as! MapPinLocationViewController
        viewController.studentInformation = buildStudentInfo(coordinate)
        navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        var firstName = ""
        var lastName = ""
        if let textName = textFieldName.text {
            let nameComponents = textName.components(separatedBy: " ")
            firstName = nameComponents.first ?? ""
            lastName = nameComponents.last ?? ""
        }
        
        let studentInfo = [
            "uniqueKey": UdacityUtils.shared.getClient()?.account.key ?? "AER234",
            "firstName": firstName,
            "lastName":  lastName,
            "mapString": textFieldLocation.text ?? "",
            "mediaURL": textFieldLink.text ?? "",
            "latitude": Float(coordinate.latitude),
            "longitude": Float(coordinate.longitude),
            ] as [String: AnyObject]
        
        let student = StudentInformation(studentInfo)
        return student
    }
    
    private func enableControllers(_ enable: Bool) {
        self.enableUI(views: textFieldLocation, textFieldLink, buttonFindLocation, enable: enable)
    }
    
}

// MARK: - TextField Delegate
extension AddLocationViewController: UITextFieldDelegate  {
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = getKeyboardRect(notification).origin.y - (buttonFindLocation.frame.origin.y + buttonFindLocation.frame.size.height + 10)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func getKeyboardRect(_ notification:Notification) -> CGRect {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
}
