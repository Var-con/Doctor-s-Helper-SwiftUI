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
    @State var isPresented = false
    @ObservedObject private var lists = ListsOfUnworking()
    
    var body: some View {
        NavigationLink(destination: DeatailInfoView(list: list, isActive: $isPresented), isActive: $isPresented) {
            ZStack {
                if list.endDate > Date() {
                    Color.green.blur(radius: 10).brightness(0.6)
                } else if list.endDate < Date() {
                    Color.red.blur(radius: 10).brightness(0.6)
                }
                VStack {
                    HStack {
                        Text("Лист нетрудоспособности: № ")
                        Text("\(list.listNumber)")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .frame(height: 50)
                    HStack {
                        Text("Дата окончания нетрудоспособности: ")
                        Spacer()
                        Text(DateFormatter.localizedString(from: list.endDate, dateStyle: .medium, timeStyle: .none))
                            .fontWeight(.bold)
                    }
                    Text("Всего дней: \(self.list.totalDays)")
                    Spacer()
                    ForEach(lists.fetchListWithPrevioslyNumber()) { nextList in
                        if nextList.previoslyListNumber == self.list.listNumber {
                            VStack{
                                HStack{
                                    Text("Лист продолжения: ")
                                    Text("\(nextList.listNumber)").fontWeight(.bold)
                                    Spacer()
                                }
                                Spacer()
                                HStack {
                                    Text("Дата окончания нетрудоспособности: ")
                                    Spacer()
                                    Text(DateFormatter.localizedString(from: nextList.endDate, dateStyle: .medium, timeStyle: .none))
                                        .fontWeight(.bold)
                                }
                                Spacer()
                                Text("Общее количество дней: \(self.list.totalDays + nextList.totalDays)").fontWeight(.bold)
                                Spacer()
                            }
                        }
                    }
                    Text("Больше информации.")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct RowList_Previews: PreviewProvider {
    static var previews: some View {
        RowList(list: ListOfUnworking(id: 12,
                                      listNumber: "12",
                                      totalDays: 1,
                                      startDate: Date(),
                                      endDate: Date())).frame(height: 150)
    }
}
