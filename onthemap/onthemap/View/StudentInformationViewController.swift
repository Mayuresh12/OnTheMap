//
//  StudentInformationViewController.swift
//  onthemap
//
//  Created by Mayuresh Rao on 7/18/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

// MARK: - StudentInformationViewController: UIViewController, UITextFieldDelegate

class StudentInformationViewController: UIViewController, UITextFieldDelegate {
    // MARK: Outlets

    @IBOutlet weak var findOnTheMapOutlet: UIButton!
    @IBOutlet weak var enterLocationOutlet: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Actions

    @IBAction func cancelButton(_ sender: Any) {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        mapVC.modalPresentationStyle = .fullScreen
        self.present(mapVC, animated: true, completion: nil)
    }
    
    @IBAction func findOntheMapButton(_ sender: Any) {
        let location = StudentLocation(mapString: enterLocationOutlet.text!)
        self.setActivityIndicator(true)
        findLocation(location)
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
    
    // MARK: LifeCycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        findOnTheMapOutlet.layer.cornerRadius = 10
        enterLocationOutlet.layer.cornerRadius = 10
        enterLocationOutlet.delegate = self
    }
    
    // send data to studentInformation view controller and ask user to enter url
    func findLocation(_ search: StudentLocation) {
        CLGeocoder().geocodeAddressString(search.mapString!) { (placemarks, _) in
            guard let firstLocation = placemarks?.first?.location else {
                let alert = UIAlertController(title: "Error", message: "Location not found ", preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    return
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            var location = search
            location.latitude = firstLocation.coordinate.latitude
            location.longitude = firstLocation.coordinate.longitude
            self.performSegue(withIdentifier: "studentInformation", sender: location)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.setActivityIndicator(false)
        if segue.identifier == "studentInformation", let viewController = segue.destination as? InforamtionpostingViewController {
            viewController.location = (sender as! StudentLocation)
        }
    }
    
    // Dismiss Keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        enterLocationOutlet.resignFirstResponder()
        return true
    }
    
    // MARK: Activity
    func setActivityIndicator(_ logginIn: Bool) {
        if logginIn {
            DispatchQueue.main.async {
                
                self.activityIndicator.startAnimating()
            }
        } else {
            DispatchQueue.main.async {
                
                self.activityIndicator.stopAnimating()
            }
        }
        DispatchQueue.main.async {
            self.findOnTheMapOutlet.isHidden = !logginIn
            self.enterLocationOutlet.isHidden = !logginIn
        }
        
    }
}
