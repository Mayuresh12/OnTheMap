//
//  UserInfo.swift
//  onthemap
//
//  Created by Mayuresh Rao on 6/13/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.

import Foundation
/*
 {
     "account": {
         "registered": true,
         "key": "34910346122"
 },
     "session": {
         "id": "3360028208Sb8624b2840ef1e8e1a8f25c7cbcc1f9e",
         "expiration": "2020-07-13T01:03:58.915413Z"
     }
 }
 */
struct Account: Codable {
    let registered: Bool
    let key: String
}
struct Session: Codable {
    let id: String
    let expiration: String
}

struct UserInfo: Codable {

    let account: Account
    let session: Session
}
