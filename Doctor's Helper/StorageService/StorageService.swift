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
    
    
}
