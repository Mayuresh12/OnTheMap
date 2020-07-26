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
    }
    
    enum EndPoints {
        static let base = "https://onthemap-api.udacity.com/v1"
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(UserInfo.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    class func getSession (username: String, password: String) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            let range = (5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            print("Session Id == \(Auth.sessionId)")
            
        }
        task.resume()
        
    }
    
    
    class func getStudentLocation(completion: @escaping ([StudentLocation]?, Error?)->()){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
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
    
    class func postStudentLocation(location: StudentLocation, completion: @escaping (_ success: Bool, _ error: String?) -> Void ){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String:Any] = [
                 "uniqueKey": location.uniqueKey ?? " ",
                 "firstName": location.firstName ?? "firstName",
                 "lastName": location.lastName ?? "lastName",
                 "mapString" :location.mapString!,
                 "mediaURL": location.mediaURL ?? "www.google.com",
                 "latitude": location.latitude!,
                 "longitude":location.longitude!,
                 ]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        request.httpBody = jsonData
//        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
}
