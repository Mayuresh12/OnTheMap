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

class StudentInformationViewController: UIViewController, UITextFieldDelegate {
 
    
    @IBOutlet weak var findOnTheMapOutlet: UIButton!
    @IBOutlet weak var enterLocationOutlet: UITextField!
    
    
  
    @IBAction func cancelButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        findOnTheMapOutlet.layer.cornerRadius = 10
        enterLocationOutlet.layer.cornerRadius = 10
        enterLocationOutlet.delegate = self
    }
    
    @IBAction func findOntheMapButton(_ sender: Any) {
        let location = StudentLocation(mapString: enterLocationOutlet.text!)
        findLocation(location)
    }

    func findLocation(_ search: StudentLocation) {
        CLGeocoder().geocodeAddressString(search.mapString!) { (placemarks, error) in
            guard let firstLocation = placemarks?.first?.location else {
                let alert = UIAlertController(title: "Erorr", message: "Location not found ", preferredStyle: .alert )
                alert.addAction(UIAlertAction (title: "OK", style: .default, handler: { _ in
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
        if segue.identifier == "studentInformation", let vc = segue.destination as? InforamtionpostingViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
      {
          enterLocationOutlet.resignFirstResponder()
          return true;
      }
}
