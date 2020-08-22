//
//  CalculatingService.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 19.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import Foundation

class CalculatingService {
    static let shared = CalculatingService()
    
    init() {}
    func getDays(from startDate: Date, to endDate: Date) -> Int{
        guard endDate >= startDate else { return 0}
        let targetValue = DateInterval(start: startDate, end: endDate)
        let resultSeconds = lround(targetValue.duration / 86400) + 1
        return resultSeconds
    }
    
    
    
    func savingToStorage(listNumber: String, startDate: Date, endDate: Date) -> ListOfUnworking {
        let totalDays = getDays(from: startDate, to: endDate)
        let listOfUnworking = ListOfUnworking(
            id: Int(listNumber),
            listNumber: listNumber,
            totalDays: totalDays,
            startDate: startDate,
            endDate: endDate)
        return listOfUnworking
    }
}
