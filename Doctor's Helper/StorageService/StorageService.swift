//
//  StorageService.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 12.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    private let arrayKey = "list"
     private let keyStrings = "ContinueStrings"
    private init() {}
    
    func saveList(with list: ListOfUnworking) {
        var lists = fetchLists()
        lists.append(list)
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.setValue(data, forKeyPath: arrayKey)
    }
    
    func fetchLists() -> [ListOfUnworking] {
        guard let data = userDefaults.object(forKey: arrayKey) as? Data else { return [] }
        guard let lists = try? JSONDecoder().decode([ListOfUnworking].self, from: data) else { return [] }
        
        return lists
    }

    func deleteList(at index: Int) {
        var lists = fetchLists()
        lists.remove(at: index)
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.setValue(data, forKey: arrayKey)
        return
    }
    
    func saveArrayOfLists(with lists: [ListOfUnworking]) {
         guard let data = try? JSONEncoder().encode(lists) else { return }
         userDefaults.setValue(data, forKeyPath: arrayKey)
     }
}

extension StorageManager {
    
    func saveContinueListString(with list: ContinueListWithoutNumber) {
        var lists = fetchListsString()
        lists.append(list)
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.setValue(data, forKeyPath: keyStrings)
    }
    
    func fetchListsString() -> [ContinueListWithoutNumber] {
        guard let data = userDefaults.object(forKey: keyStrings) as? Data else { return [] }
        guard let lists = try? JSONDecoder().decode([ContinueListWithoutNumber].self, from: data) else { return [] }
        return lists
    }

    func deleteListInListsOfStrings(with listNumber: String) {
        
        var lists = fetchListsString()
        for (index, list) in lists.enumerated() {
            print(index)
            if list.listNumber == listNumber {
                if index < lists.count {
                        lists.remove(at: index)
                } else {
                    lists.remove(at: 0)
                }
            }
        }
        guard let data = try? JSONEncoder().encode(lists) else { return }
        userDefaults.setValue(data, forKey: keyStrings)
        return
    }
    
    func saveArrayOfListsStingsContinue(with lists: [ContinueListWithoutNumber]) {
         guard let data = try? JSONEncoder().encode(lists) else { return }
         userDefaults.setValue(data, forKeyPath: arrayKey)
     }
}
