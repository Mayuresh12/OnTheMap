//
//  StudentInformationViewController.swift
//  onthemap
//
//  Created by Mayuresh Rao on 7/18/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import Foundation
import UIKit

class StudentInformationViewController: UIViewController {
 
    
    @IBOutlet weak var findOnTheMapOutlet: UIButton!
    @IBOutlet weak var enterLocationOutlet: UITextField!
    
    
    @IBAction func findOntheMapButton(_ sender: Any) {
    }
  
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        findOnTheMapOutlet.layer.cornerRadius = 10
        enterLocationOutlet.layer.cornerRadius = 10
        
    }
}
