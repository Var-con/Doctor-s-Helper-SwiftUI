//
//  ListModel.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import Foundation

struct ListOfUnworking: Codable, Identifiable, Equatable, Comparable {
    static func < (lhs: ListOfUnworking, rhs: ListOfUnworking) -> Bool {
        lhs.endDate < rhs.endDate
    }
    
    var id: String
    var listNumber: String
    var totalDays: Int
    var startDate: Date
    var endDate: Date
    var previoslyListNumber: String?
    
    
}
