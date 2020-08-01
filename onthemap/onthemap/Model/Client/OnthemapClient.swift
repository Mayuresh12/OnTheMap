//
//  onthemapClient.swift
//  onthemap
//
//  Created by Mayuresh Rao on 6/13/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import Foundation

class OnTheMapClient {

    struct Auth {
        static var accountId = ""
        static var sessionId = ""
        static var firstName = "Jack"
        static var lastName = "Hanma"
    }

    /*
     URl
     SCHEME
     HOST
     PORT
     PATH
     */

    struct OnTheMap {
        static let scheme = "https"
        static let host = "onthemap-api.udacity.com"
        static let udacityPath = "/v1"
    }
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"

        case createSession
        case deleteSession
        case getStudetnLocation
        case webSignUp
        case getPublicUserData
        var stringValue: String {
            switch self {
            case .createSession: return EndPoints.base + "/session"
            case .getStudetnLocation: return EndPoints.base + "/StudentLocation?order=-updatedAt"
            case .deleteSession: return EndPoints.base + "/session"
            case .webSignUp: return "https://auth.udacity.com/sign-up"
            case .getPublicUserData: return EndPoints.base + "/users/\(Auth.accountId)"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }
    }

    class func login(username: String, password: String, completionHandler: @escaping (UserInfo?, Error?) -> Void) {
        var request = URLRequest(url: EndPoints.createSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        let body = Udacity.init(udacity: LoginRequest(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            guard let data = newData else {
                print("Oops Someting went Wrong!!")
                completionHandler(nil, error)
                return
            }
            do {
                let decoder = JSONDecoder()
                let userData = try decoder.decode(UserInfo.self, from: data)
                Auth.accountId = userData.account.key
                Auth.sessionId = userData.session.id
                completionHandler(userData, nil)
            } catch {
                completionHandler(nil, error)
                print(error)
            }
            print(String(data: newData!, encoding: .utf8)!)
            print("Session Id == \(Auth.sessionId)")
            print("Account Key == \(Auth.accountId)")

        }
        task.resume()

    }

    class func getStudentLocation(completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        let request = URLRequest(url: EndPoints.getStudetnLocation.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            guard let data = data else {
                return
            }
            if error != nil { // Handle error...
                return
            }
            let decoder = JSONDecoder()

            do {
                let responseObject = try decoder.decode( Result.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                print("Oh Man ERROR!!!!!")
            }
        }
        task.resume()
    }

    class func postStudentLocation(location: StudentLocation, completion: @escaping (_ success: Bool, _ error: String?) -> Void ) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = [
                 "uniqueKey": location.uniqueKey ?? " ",
                 "firstName": location.firstName ?? "firstName",
                 "lastName": location.lastName ?? "lastName",
                 "mapString": location.mapString!,
                 "mediaURL": location.mediaURL ?? "www.google.com",
                 "latitude": location.latitude!,
                 "longitude": location.longitude!
                 ]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = jsonData
//        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }

    // TODO have to work on the model
    class func getPublicUserData(completion: @escaping(_ success: Bool, _ student: StudentLocation?, _ error: String?) -> Void) {
        let request = URLRequest(url: EndPoints.getPublicUserData.url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
            if error != nil { // Handle error...
                completion(false, nil, error?.localizedDescription)
                return
            }
            guard let data = data else {
                completion(false, nil, error?.localizedDescription)
                return
            }

            let range = (5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)

            let decoder = JSONDecoder()
            let decodedData = try! decoder.decode(StudentLocation.self, from: newData)
            var student = StudentLocation()
            student.firstName = decodedData.firstName
            student.lastName = decodedData.lastName
            student.uniqueKey = Auth.accountId
            completion(true, student, nil)
        }
        task.resume()
    }

    // TODO have to work on the model
    class func updateExitingStudentLocation() {
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // swiftlint:disable:next line_length
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }

    // TODO have to work in the model
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie?
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, _, error in
          if error != nil { // Handle error…
              return
          }
          let range = (5..<data!.count)
          let newData = data?.subdata(in: range) /* subset response data! */
            Auth.accountId = ""
            Auth.sessionId = ""
            completion()
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
}
