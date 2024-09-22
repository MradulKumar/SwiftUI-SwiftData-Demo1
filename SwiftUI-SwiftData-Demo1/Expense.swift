//
//  Item.swift
//  SwiftUI-SwiftData-Demo1
//
//  Created by Mradul Kumar on 22/09/24.
//

import Foundation
import SwiftData

@Model
final class Expense {
    var name: String
    var date: Date
    var value: Double
    
    init(name: String, date: Date, value: Double) {
        self.name = name
        self.date = date
        self.value = value
    }
}
