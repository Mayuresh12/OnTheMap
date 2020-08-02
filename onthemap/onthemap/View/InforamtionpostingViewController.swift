//
//  InforamtionpostingViewController.swift
//  onthemap
//
//  Created by Mayuresh Rao on 7/25/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class InforamtionpostingViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {
    var location: StudentLocation?
    var isHidden = false
    @IBOutlet weak var locationTextFeild: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var submitButtonOutlet: UIButton!
    @IBOutlet weak var hideCardAndButtons: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        submitButtonOutlet.isHidden = isHidden
        locationTextFeild.isHidden = isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        submitButtonOutlet.isEnabled = false
        submitButtonOutlet.backgroundColor = .gray
        locationTextFeild.delegate = self
        locationTextFeild.attributedPlaceholder = NSAttributedString(string: "Enter a link to share here.",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        showPin()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextFeild.resignFirstResponder()
          return true
      }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        submitButtonOutlet.isEnabled = true
        submitButtonOutlet.backgroundColor = .systemGreen
        return true
    }
    @IBAction func submitButton(_ sender: Any) {
        if locationTextFeild.text?.isEmpty == true {
            let alert = UIAlertController(title: "Please Enter Location", message: "Enter url for your profile.", preferredStyle: .alert )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                return
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            //Get public User Data
            OnTheMapClient.getPublicUserData { (success, studentInfo, error) in
                if success {
                    DispatchQueue.main.async {

                    self.location?.uniqueKey = studentInfo?.uniqueKey
                    self.location?.firstName = studentInfo?.firstName
                    self.location?.lastName = studentInfo?.lastName
                    self.location?.mapString = "Nagpur"
                    self.location?.mediaURL =  self.locationTextFeild.text
                    self.location?.longitude = studentInfo?.longitude
                    self.location?.latitude = studentInfo?.latitude
                    }
                    //Post public user data
                    OnTheMapClient.postStudentLocation(location: self.location!) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                                        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                                                        mapVC.modalPresentationStyle = .fullScreen
                                                        self.present(mapVC, animated: true, completion: nil)
                            }
                        } else {
                            self.showLoginFailure(message: error!.localizedDescription)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showLoginFailure(message: error!.localizedDescription)
                    }
                }
            }
            
        }
    }

    @IBAction func cancelButton(_ sender: Any) {
        
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        mapVC.modalPresentationStyle = .fullScreen
        self.present(mapVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        OnTheMapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: {
                    let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "loginScreen")
                    mapVC!.modalPresentationStyle = .fullScreen
                    self.present(mapVC!, animated: true, completion: nil)
                })
            }
        }
    }
  
    func showPin() {
                guard let location = location else { return }
                let latitude = CLLocationDegrees(location.latitude!)
                let longitude = CLLocationDegrees(location.longitude!)
                let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = location.mapString
                annotation.subtitle = location.mediaURL
                mapView.addAnnotation(annotation)
                let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapView.setRegion(region, animated: true)
    }
    // MARK: - MKMapViewDelegate

       // Here we create a view with a "right callout accessory view". You might choose to look into other
       // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
       // method in TableViewDataSource.
       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

           let reuseId = "pin"

           var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

           if pinView == nil {
               pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
               pinView!.canShowCallout = true
               pinView!.pinTintColor = .red
               pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
           } else {
               pinView!.annotation = annotation
           }

           return pinView
       }

    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
