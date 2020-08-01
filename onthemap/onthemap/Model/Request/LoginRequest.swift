//
//  LoginRequest.swift
//  onthemap
//
//  Created by Mayuresh Rao on 7/31/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import Foundation

struct Udacity: Codable {
    var udacity: LoginRequest
}
struct LoginRequest: Codable {
    let username: String
    let password: String
}
