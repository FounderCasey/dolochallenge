//
//  Location.swift
//  dolochallenge
//
//  Created by Casey Wilcox on 2/17/18.
//  Copyright © 2018 Casey Wilcox. All rights reserved.
//

import Foundation

struct Location: Codable {
    var name: String
    var address: String
    var distance: Int
    
    init(name: String, address: String, distance: Int) {
        self.name = name
        self.address = address
        self.distance = distance
    }
}
