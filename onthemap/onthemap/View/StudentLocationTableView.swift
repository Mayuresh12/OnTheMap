//
//  StudentLocationTableView.swift
//  onthemap
//
//  Created by Mayuresh Rao on 7/12/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import UIKit

class StudentLocationTableView: UITableViewController {
    var data = [StudentLocation]()
    var count = 0
    var activityView: UIActivityIndicatorView?
    @IBOutlet var studentTableView: UITableView!
    @IBAction func reloadData(_ sender: Any) {
        DispatchQueue.main.async {
            self.studentTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showActivityIndicator()
        studentTableView.delegate = self
        studentTableView.dataSource = self
        OnTheMapClient.getStudentLocation { (result, _) in
            if let result = result {
                self.count = result.count
                self.data = result
                DispatchQueue.main.async {
                    self.studentTableView.reloadData()
                    self.hideActivityIndicator()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
                self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = studentTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StudentLocationTableViewCell
        let row = indexPath.row
        cell.studentName.text = "\(data[row].firstName!)  \(data[row].lastName!)"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("I selected the row")
    }
    func showActivityIndicator() {
        activityView = UIActivityIndicatorView(style: .gray)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    func hideActivityIndicator() {
        if activityView != nil {
            activityView?.stopAnimating()
        }
    }

}
