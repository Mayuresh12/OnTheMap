//
//  Data.swift
//  onthemap
//
//  Created by Mayuresh Rao on 7/12/20.
//  Copyright © 2020 Mayuresh Rao. All rights reserved.
//

import Foundation
class Data {
    static let shared = Data()
    var usersData = [Any?]()
    private init() { }
}
