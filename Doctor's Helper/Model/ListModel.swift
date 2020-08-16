//
//  ListModel.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import Foundation

struct ListOfUnworking: Codable, Identifiable {
    var id: Int
    var listNumber: String
    var totalDays: Int
    var startDate: Date
    var endDate: Date
    
    
}
