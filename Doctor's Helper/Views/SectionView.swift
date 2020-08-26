//
//  SectionView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 25.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct SectionView: View {
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @ObservedObject private var listsOfUnworkingStored = ListsOfUnworking()
    @State var list: ListOfUnworking
    @State var firstList: ListOfUnworking
    @State var continueIsPresented: Bool
    @State var showAskingOfDeleteAlert: Bool = false
    @Binding var isActive: Bool
    @Binding var storedContinueLists: [ListOfUnworking]
    
    var body: some View {
        
        VStack {
            if self.listsOfUnworkingStored.fetchContinueStrings(with: list.listNumber).count == 2{
                Text("Всего дней нетрудоспособности: \(list.totalDays + self.listsOfUnworkingStored.fetchContinueStrings(with: list.listNumber)[0].totalDays + self.listsOfUnworkingStored.fetchContinueStrings(with: list.listNumber)[1].totalDays)").fontWeight(.bold)
            } else if self.listsOfUnworkingStored.fetchContinueStrings(with: list.listNumber).count == 1 {
                Text("Всего дней нетрудоспособности: \(list.totalDays + self.listsOfUnworkingStored.fetchContinueStrings(with: list.listNumber)[0].totalDays)").fontWeight(.bold)
            } else {
                Text("Всего дней нетрудоспособности: \(list.totalDays)").fontWeight(.bold)
            }
            VStack {
                Text("Лист нетрудоспособности: № ")
                Text("\(list.listNumber)")
                    .fontWeight(.bold)
            }
            HStack {
                Text("Дата начала нетрудоспособности: ")
                Spacer()
                Text(DateFormatter.localizedString(from: list.startDate,
                                                   dateStyle: .medium,
                                                   timeStyle: .none))
                    .fontWeight(.bold)
            }
            
            HStack {
                Button(action: {
                    self.continueIsPresented.toggle()
                }) {
                    Text("Продлить")
                }
                .sheet(isPresented: $continueIsPresented) {
                    ContinueWithStringCalculate(list: self.list,
                                                showModal: self.$continueIsPresented,
                                                date: self.list.endDate)
                }
                .disabled(listsOfUnworkingStored.fetchContinueStrings(with: list.listNumber).count == 2)
                
                Spacer()
                Button( action: {
                    self.showAskingOfDeleteAlert.toggle()
                }) {
                    Text("Удалить").fontWeight(.bold)
                }
                .frame(width: 100, height: 30)
                .modifier(DeleteButtonModifier())
            }
            .alert(isPresented: self.$showAskingOfDeleteAlert) {
                Alert(title: Text("Вы точно хотите удалить л/н?"),
                      primaryButton: Alert.Button.destructive(Text("Да"), action: {
                        self.deleteList(list: self.list)
                      }),
                      secondaryButton: Alert.Button.cancel())
            }
            if self.listsOfUnworkingStored.fetchContinueStrings(with: list.listNumber) != [] {
                ForEach(self.listsOfUnworkingStored.fetchContinueStrings(with: list.listNumber), id: \.endDate) { continueString in
                VStack {
                    if continueString.numberOfString == .second {
                        Text("Вторая строка")
                    } else {
                        Text("Третья строка")
                    }
                    HStack {
                        Text("Дата начала: ")
                        Spacer()
                        Text(DateFormatter.localizedString(from: continueString.startDate,
                                                           dateStyle: .medium,
                                                           timeStyle: .none))
                            .fontWeight(.bold)
                    }
                    HStack {
                        Text("Дата окончания: ")
                        Spacer()
                        Text(DateFormatter.localizedString(from: continueString.endDate,
                                                           dateStyle: .medium,
                                                           timeStyle: .none))
                            .fontWeight(.bold)
                        
                    }
                    Text("Всего дней: \(continueString.totalDays)")
                }
            }
            } else {
                HStack {
                    Text("Дата окончания нетрудоспособности: ")
                    Spacer()
                    Text(DateFormatter.localizedString(from: list.endDate,
                                                       dateStyle: .medium,
                                                       timeStyle: .none))
                        .fontWeight(.bold)
                }
            }
        }
        .padding()
        .modifier(SectionModifier())
        .padding(.top, 20)
    }
}


extension SectionView {
    
    func deleteList(list: ListOfUnworking) {
        var listsArray = listsOfUnworkingStored.fetchLists()
        for (index, listOfUnwork) in listsArray.enumerated() {
            if let previosListNumber = listOfUnwork.previoslyListNumber {
                if previosListNumber == list.listNumber,
                    index < listsArray.count {
                    listsArray.remove(at: index)
                    appDelegate?.notificationCente.removePendingNotificationRequests(withIdentifiers: ["Local Notification \(listOfUnwork.listNumber)"])
                }
            }
            for (index, listOfUnwork) in listsArray.enumerated() {
                if listOfUnwork.listNumber == list.listNumber,
                    index < listsArray.count {
                    listsArray.remove(at: index)
                    appDelegate?.notificationCente.removePendingNotificationRequests(withIdentifiers: ["Local Notification \(list.listNumber)"])
                    StorageManager.shared.deleteListInListsOfStrings(with: listOfUnwork.listNumber)
                }
            }
        }
        StorageManager.shared.deleteListInListsOfStrings(with: list.listNumber)
        StorageManager.shared.saveArrayOfLists(with: listsArray)
        if self.firstList.listNumber == list.listNumber {
            isActive.toggle()
        }
        self.storedContinueLists = self.listsOfUnworkingStored.fetchListWithPrevioslyNumber()
    }
    
}
