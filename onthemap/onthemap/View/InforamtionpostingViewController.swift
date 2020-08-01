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
class InforamtionpostingViewController: UIViewController, UITextFieldDelegate {
    var location: StudentLocation?

    @IBOutlet weak var locationTextFeild: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextFeild.delegate = self
        showPin()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        locationTextFeild.resignFirstResponder()
          return true
      }

    @IBAction func submitButton(_ sender: Any) {
        OnTheMapClient.postStudentLocation(location: self.location!) { (success, error) in
            guard error == nil else {
                            print("Error")
                            return
                    }
                if success {
                    print("success")
                } else {
                    print("ERROR")
                }
            }
        }

    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func logoutButton(_ sender: Any) {
        OnTheMapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
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
}
