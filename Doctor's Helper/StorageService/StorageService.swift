//
//  StorageService.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 12.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import Foundation
import CoreData


class StorageManager {
    
//        (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static let shared = StorageManager()
    private let userDefaults = UserDefaults.standard
    private let arrayKey = "list"
     private let keyStrings = "ContinueStrings"
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    private init() {}
    
    var persistentContainer: NSPersistentContainer = {
    
           let container = NSPersistentContainer(name: "Doctor'sHelper")
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {

                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
       
       // MARK: - Core Data Saving support
       
       func saveContext () {
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }
    
    func saveList(with list: ListOfUnworking) {
        guard let data = try? JSONEncoder().encode(list) else { return }
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "ListsOfUnworkingStorage", in: context) else { return }
        guard let listsOfUnworking = NSManagedObject(entity: entityDescription, insertInto: context) as? ListsOfUnworkingStorage else { return }
        listsOfUnworking.listsOFUnwork = data
        do {
            try context.save()
        } catch let error {
            print(error.localizedDescription)
        }

//        userDefaults.setValue(data, forKeyPath: arrayKey)
    }
    

    func fetchLists() -> [ListOfUnworking] {
        var lists: [ListsOfUnworkingStorage] = []
        var newlists: [ListOfUnworking] = []
        let fetchRequest: NSFetchRequest<ListsOfUnworkingStorage> = ListsOfUnworkingStorage.fetchRequest()
        do {
            lists = try context.fetch(fetchRequest)
        }
        catch let error {
            print(error.localizedDescription)
        }
        for listsOfUW in lists {
        guard let dataFromStorageList = listsOfUW.listsOFUnwork else { return [] }
        guard let arrayOfStorageLists = try? JSONDecoder().decode(ListOfUnworking.self, from: dataFromStorageList) else { return [] }
            newlists.append(arrayOfStorageLists)
        }
        return newlists
    }

    func deleteList(list: ListOfUnworking) {
        let fetchRequest: NSFetchRequest<ListsOfUnworkingStorage> = ListsOfUnworkingStorage.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                guard let listdata = object.listsOFUnwork else { return }
                guard let listofUW = try? JSONDecoder().decode(ListOfUnworking.self, from: listdata) else { return }
                if listofUW.listNumber == list.listNumber {
                    context.delete(object)
                }
            }
        }
        
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
    
    func deleteListInListsOfStringsWithNumberOfString(with listNumber: String, stringNumber: NumberOfContinueString) {
          
          var lists = fetchListsString()
          for (index, list) in lists.enumerated() {
            if list.listNumber == listNumber, list.numberOfString == stringNumber {
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


extension StorageManager {
    
    func deleteListFromStorage(list: ListOfUnworking) {
        let listsOfUnworkingStored = ListsOfUnworking()

        var listsArray = listsOfUnworkingStored.fetchLists()
    
        for (index, listOfUnwork) in listsArray.enumerated() {
            if listOfUnwork.listNumber == list.listNumber,
                index < listsArray.count {
                listsArray.remove(at: index)
                StorageManager.shared.deleteListInListsOfStrings(with: listOfUnwork.listNumber)
            }
        }
            for (index, listOfUnwork) in listsArray.enumerated() {
                if listOfUnwork.previoslyListNumber ?? "" == list.listNumber, index < listsArray.count {
                listsArray.remove(at: index)
                StorageManager.shared.deleteListInListsOfStrings(with: listOfUnwork.listNumber)
                }
        }
        
        for (index, listOfUnwork) in listsArray.enumerated() {
                if listOfUnwork.previoslyListNumber ?? "" == list.listNumber, index < listsArray.count {
                listsArray.remove(at: index)
                StorageManager.shared.deleteListInListsOfStrings(with: listOfUnwork.listNumber)
                }
        }
        StorageManager.shared.saveArrayOfLists(with: listsArray)
    }
}
