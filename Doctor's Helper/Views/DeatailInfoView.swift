//
//  DeatailInfoView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 20.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct DeatailInfoView: View {
    
    var list: ListOfUnworking
    @State private var isPresented = false
    @ObservedObject private var lists = ListsOfUnworking()
    @Binding var isActive: Bool
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                VStack {
                    VStack {
                        Text("Лист нетрудоспособности: № ")
                        Text("\(list.listNumber)")
                            .fontWeight(.bold)
                    }
                    HStack {
                        Text("Дата начала нетрудоспособности: ")
                        Spacer()
                        Text(DateFormatter.localizedString(from: list.startDate, dateStyle: .medium, timeStyle: .none))
                            .fontWeight(.bold)
                    }
                    HStack {
                        Text("Дата окончания нетрудоспособности: ")
                        Spacer()
                        Text(DateFormatter.localizedString(from: list.endDate, dateStyle: .medium, timeStyle: .none))
                            .fontWeight(.bold)
                    }
                    HStack {
                        Spacer()
                        Button( action: {
                            self.deleteList(list: self.list)
                            self.isActive = false
                        }) {
                            Text("Удалить").fontWeight(.bold)
                        }
                        .frame(width: 100, height: 30)
                        .background(Color.init(red: 1, green: 0, blue: 0))
                        .foregroundColor(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.blue, lineWidth: 2))
                    }
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 3))
                .padding(.top, 20)
                Spacer()
                VStack {
                    ForEach(lists.fetchListWithPrevioslyNumber()) { nextList in
                        if nextList.previoslyListNumber == self.list.listNumber {
                            VStack{
                                VStack {
                                    VStack{
                                        Text("Номер листа продолжения: ")
                                        Text("\(nextList.listNumber)").fontWeight(.bold)
                                    }
                                    HStack {
                                        Text("Дата начала нетрудоспособности: ")
                                        Spacer()
                                        Text(DateFormatter.localizedString(from: nextList.startDate, dateStyle: .medium, timeStyle: .none))
                                            .fontWeight(.bold)
                                    }
                                    HStack {
                                        Text("Дата окончания нетрудоспособности: ")
                                        Spacer()
                                        Text(DateFormatter.localizedString(from: nextList.endDate, dateStyle: .medium, timeStyle: .none))
                                            .fontWeight(.bold)
                                    }
                                    Text("Всего дней: \(self.list.totalDays + nextList.totalDays)")
                                    HStack {
                                        Spacer()
                                        Button( action: {
                                            self.deleteList(list: nextList)
                                            self.isActive = false
                                        }) {
                                            Text("Удалить").fontWeight(.bold)
                                        }
                                        .frame(width: 100, height: 30)
                                        .background(Color.init(red: 1, green: 0, blue: 0))
                                        .foregroundColor(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.blue, lineWidth: 2))
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay(RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.blue, lineWidth: 3))
                                .padding(.top, 20)
                            }
                        }
                    }
                }
                
                Button(action: { self.isPresented.toggle() }) {
                    Text("Создать продолжение")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }.sheet(isPresented: $isPresented) {
                    ContinueList(list: self.list, showModal: self.$isPresented, date: self.list.endDate)
                }
                .frame(width: 200, height: 70)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.green, lineWidth: 3))
                .padding(.top, 20)
                Spacer()
            }
                
            .padding()
        }
        .background(Color.green.blur(radius: 10).brightness(0.6))
    }
}

struct DeatailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeatailInfoView(list: ListOfUnworking(id: 12, listNumber: "12", totalDays: 2, startDate: Date(), endDate: Date()), isActive: .constant(false))
    }
}


extension DeatailInfoView {
    func deleteList(list: ListOfUnworking) {
        var listsArray = lists.fetchLists()
        for (index, listOfUnwork) in listsArray.enumerated() {
            if listOfUnwork.listNumber == list.listNumber {
                if index < listsArray.count {
                listsArray.remove(at: index)
                }
            }
        }
        StorageManager.shared.saveArrayOfLists(with: listsArray)
    }
}
