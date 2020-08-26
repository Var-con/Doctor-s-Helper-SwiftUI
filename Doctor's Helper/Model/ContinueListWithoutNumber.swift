//
//  ContinueListWithoutNumber.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 22.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import Foundation

struct ContinueListWithoutNumber: Codable, Equatable {
    var startDate: Date
    var endDate: Date
    var numberOfString: NumberOfContinueString
    var totalDays: Int
    var listNumber: String
}
