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
    @State var storedStrings: [ContinueListWithoutNumber] = []
    
    var body: some View {
        
        VStack {
            if storedStrings.count == 2 {
                Text("Всего дней нетрудоспособности: \(list.totalDays + self.storedStrings[0].totalDays + self.storedStrings[1].totalDays)").fontWeight(.bold)
            } else if self.storedStrings.count == 1 {
                Text("Всего дней нетрудоспособности: \(list.totalDays + self.storedStrings[0].totalDays)").fontWeight(.bold)
            } else {
                Text("Всего дней нетрудоспособности: \(list.totalDays)").fontWeight(.bold)
            }
            VStack {
                Text("Лист нетрудоспособности: № ")
                Text("\(list.listNumber)")
                    .fontWeight(.bold)
            }
            HStack {
                Text("Дата начала: ")
                Spacer()
                Text(DateFormatter.localizedString(from: list.startDate,
                                                   dateStyle: .medium,
                                                   timeStyle: .none))
                    .fontWeight(.bold)
            }
            if self.storedStrings == [] {
                HStack {
                    Text("Дата окончания нетрудоспособности: ")
                    Spacer()
                    Text(DateFormatter.localizedString(from: list.endDate,
                                                       dateStyle: .medium,
                                                       timeStyle: .none))
                        .fontWeight(.bold)
                }
            }
            HStack {
                Button(action: {
                    self.continueIsPresented.toggle()
                }) {
                    Text("Продлить").fontWeight(.bold)
                }
                .frame(width: 100, height: 30)
                .modifier(CommonWhiteButtonModifier())
                .sheet(isPresented: $continueIsPresented) {
                    ContinueWithStringCalculate(list: self.list,
                                                showModal: self.$continueIsPresented,
                                                date: self.list.endDate,
                                                storedString: self.$storedStrings)
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
            .padding()
            .alert(isPresented: self.$showAskingOfDeleteAlert) {
                Alert(title: Text("Вы точно хотите удалить л/н?"),
                      primaryButton: Alert.Button.destructive(Text("Да"), action: {
                        StorageManager.shared.deleteList(list: self.list)
                        if self.list.listNumber == self.firstList.listNumber {
                            self.isActive.toggle()
                        }
                        self.storedContinueLists = self.listsOfUnworkingStored.fetchLists()
                      }),
                      secondaryButton: Alert.Button.cancel())
            }
            if self.storedStrings != [] {
                ForEach(storedStrings, id: \.endDate) { continueString in
                    VStack {
                        HStack {
                            continueString.numberOfString == .second ? Text("Вторая строка:").fontWeight(.bold) : Text("Третья строка:").fontWeight(.bold)
                            Spacer()
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
                        HStack {
                            if continueString == self.storedStrings.last {
                            Spacer()
                            Button("Удалить строку") {
                                StorageManager.shared.deleteListInListsOfStringsWithNumberOfString(
                                    with: continueString.listNumber,
                                    stringNumber: continueString.numberOfString
                                )
                                self.storedStrings = self.listsOfUnworkingStored.fetchContinueStrings(with: self.list.listNumber)
                            }
                            }
                        }
                    }
                }
            } 
        }
        .padding()
        .modifier(SectionModifier())
        .padding(.top, 20)
        .onAppear {
            self.storedStrings = self.listsOfUnworkingStored.fetchContinueStrings(with: self.list.listNumber)
        }
    }
}
