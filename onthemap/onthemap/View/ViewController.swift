//
//  ViewController.swift
//  onthemap
//
//  Created by Mayuresh Rao on 6/12/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func loginButton(_ sender: Any) {
        let username = self.username.text ?? ""
        let password = self.password.text ?? ""
        OnTheMapClient.getSession(username: username, password: password)
    }
    

}

