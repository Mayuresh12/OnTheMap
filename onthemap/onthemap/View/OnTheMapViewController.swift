//
//  OnTheMapViewController.swift
//  onthemap
//
//  Created by Mayuresh Rao on 7/11/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import UIKit
import MapKit

    // MARK: - OnTheMapViewController: UIViewController, MKMapViewDelegate
class OnTheMapViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Outlet

    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Actions
    
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

    // MARK: LifeCycle Methods
    
    override func  viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        var annotations = [MKPointAnnotation]()
        
        OnTheMapClient.getStudentLocation { (result, _) in
            if let result = result {
                DispatchQueue.main.async {
                    for location in result {
                        let long = CLLocationDegrees(location.longitude! )
                        let lat = CLLocationDegrees(location.latitude! )
                        let cords = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        let mediaURL = location.mediaURL!
                        let firstName = location.firstName!
                        let lastName = location.lastName!
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = cords
                        annotation.title = "\(firstName) \(lastName)"
                        annotation.subtitle = mediaURL
                        annotations.append(annotation)
                    }
                    // When the array is complete, we add the annotations to the map.
                    self.mapView.addAnnotations(annotations)
                }
            }
        }
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
}
