//
//  Item.swift
//  OfficeLines
//
//  Created by Justin Funk on 9/24/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
