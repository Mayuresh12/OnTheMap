//
//  StudentLocationTableView.swift
//  onthemap
//
//  Created by Mayuresh Rao on 7/12/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import UIKit
import CoreLocation

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
        let row = indexPath.row
        let location =
            StudentLocation(createdAt: data[row].createdAt,
                            firstName: data[row].firstName,
                            lastName: data[row].lastName,
                            latitude: data[row].latitude,
                            longitude: data[row].longitude,
                            mapString: data[row].mapString,
                            mediaURL: data[row].mediaURL,
                            objectId: data[row].objectId,
                            uniqueKey: data[row].uniqueKey,
                            updatedAt: data[row].updatedAt)
        findLocation(location)
        print("I selected the row")
    }
    
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
 let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "infoScreen") as! InforamtionpostingViewController
        mapVC.modalPresentationStyle = .fullScreen
            mapVC.location = search
            mapVC.isHidden = true
        self.present(mapVC, animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoScreen", let viewController = segue.destination as? InforamtionpostingViewController {
            viewController.location = (sender as! StudentLocation)
        }
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
