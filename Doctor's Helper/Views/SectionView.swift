//
//  SectionView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 25.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct SectionView: View {
    
    private let listsOfUnworkingStored = ListsOfUnworking()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @State var list: ListOfUnworking
    @State var continueIsPresented: Bool
    @State var lists: [ContinueListWithoutNumber] = []
    @State var showAskingOfDeleteAlert: Bool = false
    @Binding var isActive: Bool
//    @State var action: (list: ListOfUnworking) -> Void
    var body: some View {
        
        VStack {
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
                Text("Дата окончания нетрудоспособности: ")
                Spacer()
                Text(DateFormatter.localizedString(from: list.endDate,
                                                   dateStyle: .medium,
                                                   timeStyle: .none))
                    .fontWeight(.bold)
            }
            HStack {
                if lists.count < 2 {
                    Button(action: {
                        self.continueIsPresented.toggle()
                    }) {
                        Text("Продлить")
                    }.sheet(isPresented: $continueIsPresented) {
                        ContinueWithStringCalculate(list: self.list,
                                                    showModal: self.$continueIsPresented,
                                                    date: self.list.endDate)
                    }
                }
                
                
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
        }
        .onAppear {
//            self.stringsCount = self.$lists.fetchContinueStrings(with: self.list.listNumber)
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
                }
            }
        }
        StorageManager.shared.saveArrayOfLists(with: listsArray)
        if self.list.listNumber == list.listNumber {
            isActive.toggle()
        }
        
    }
 
}
