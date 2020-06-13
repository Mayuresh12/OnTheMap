//
//  UserInfo.swift
//  onthemap
//
//  Created by Mayuresh Rao on 6/13/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import Foundation


struct UserInfo: Codable {
    
    let accountId: String
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case accountId
        case sessionId
    }
}
