//
//  Lists.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 20.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI
import Combine

class ListsOfUnworking: ObservableObject {
    
        func fetchListWithoutPrevioslyNumber() -> [ListOfUnworking] {
        let list = StorageManager.shared.fetchLists().filter { $0.previoslyListNumber == nil }
        return list
    }
    
    func fetchListWithPrevioslyNumber() -> [ListOfUnworking] {
           let list = StorageManager.shared.fetchLists().filter { $0.previoslyListNumber != nil }
           return list
       }
    
    func fetchLists() -> [ListOfUnworking] {
        let list = StorageManager.shared.fetchLists()
        return list
    }
    
    func fetchContinueStrings(with listNumber: String) -> [ContinueListWithoutNumber] {
           let lists = StorageManager.shared.fetchListsString()
        var strings: [ContinueListWithoutNumber] = []
        for list in lists {
            if list.listNumber == listNumber {
            strings.append(list)
            }
        }
           return strings
       }
}
