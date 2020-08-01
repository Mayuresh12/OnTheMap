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
    @IBOutlet weak var loginViaWebButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func loginButton(_ sender: Any) {
        setLoggingIn(true)
        let username = self.username.text ?? ""
        let password = self.password.text ?? ""
        OnTheMapClient.login(username: username, password: password, completionHandler: self.handleLoginResponse(userInfo:error:))
    }

    @IBAction func loginViaWebSite(_ sender: Any) {
        setLoggingIn(true)
        UIApplication.shared.open(OnTheMapClient.EndPoints.webSignUp.url, options: [:], completionHandler: nil)
    }

    func handleLoginResponse(userInfo: UserInfo?, error: Error?) {
        setLoggingIn(false)

        if let error = error {
            DispatchQueue.main.async {

                self.showLoginFailure(message: error.localizedDescription )

            }
        }
        if  userInfo?.account.registered == true {
            DispatchQueue.main.async {

                let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(mapVC, animated: true, completion: nil)
            }
        }
    }

    func setLoggingIn(_ logginIn: Bool) {
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

            self.username.isEnabled = !logginIn
            self.password.isEnabled = !logginIn
            self.loginButtonOutlet.isEnabled = !logginIn
            self.loginViaWebButton.isEnabled = !logginIn
        }

    }

    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
