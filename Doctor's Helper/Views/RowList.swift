//
//  RowList.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 20.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct RowList: View {
    var list: ListOfUnworking
    @State private var isPresented = false
    @ObservedObject private var lists = ListsOfUnworking()
    
    var body: some View {
        Button(action: { self.isPresented.toggle() }) {
            ZStack {
                if list.endDate > Date() {
                    Color.green.blur(radius: 10).brightness(0.6)
                } else {
                    Color.red.blur(radius: 10).brightness(0.6)
                }
            VStack {
                Text("Создать продолжение")
                Text("Лист нетрудоспособности: №\(list.listNumber)")
                HStack {
                    Text("Дата начала нетрудоспособности: ")
                    Spacer()
                    Text(DateFormatter.localizedString(from: list.startDate, dateStyle: .medium, timeStyle: .none))
                }
                HStack {
                    Text("Дата окончания нетрудоспособности: ")
                    Spacer()
                    Text(DateFormatter.localizedString(from: list.endDate, dateStyle: .medium, timeStyle: .none))
                }
                ForEach(lists.fetchListWithPrevioslyNumber()) { nextList in
                    if nextList.previoslyListNumber == self.list.listNumber {
                        Text("\(nextList.previoslyListNumber!)")
                        
                    }
                    
                }
            }
            }
        }.sheet(isPresented: $isPresented) {
            ContinueList(list: self.list, showModal: self.$isPresented, date: self.list.endDate)
        }
    }
}

struct RowList_Previews: PreviewProvider {
    static var previews: some View {
        RowList(list: ListOfUnworking(id: 12,
                                      listNumber: "12",
                                      totalDays: 1,
                                      startDate: Date(),
                                      endDate: Date()))
    }
}
