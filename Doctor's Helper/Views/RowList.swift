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
        NavigationLink(destination: DeatailInfoView(list: list,
                                                    returnToPreviousScreen: $isPresented),
                       isActive: $isPresented)
        {
            VStack {
                VStack {
                HStack {
                    Text("Лист нетрудоспособности: № ")
                    Spacer()
                    }
                    Text("\(list.listNumber)")
                        .fontWeight(.bold)
                }
                .frame(height: 50)
                Spacer()
                
                if lists.fetchListWithPrevioslyNumberByNumber(list) != [] {
                    if lists.fetchContinueStrings(with: lists.fetchListWithPrevioslyNumberByNumber(list).last!.listNumber) != [] {
                        HStack {
                            Text("Дата окончания: ")
                            Spacer()
                            Text(DateFormatter.localizedString(
                                from:
                                self.lists.fetchContinueStrings(with: self.lists.fetchListWithPrevioslyNumberByNumber(list).last!.listNumber).last!.endDate,
                                dateStyle: .medium,
                                timeStyle: .none
                            ))
                                .fontWeight(.bold)
                        }
                        
                    } else {
                        HStack {
                            Text("Дата окончания: ")
                            Spacer()
                            Text(DateFormatter.localizedString(from: lists.fetchListWithPrevioslyNumberByNumber(list).last!.endDate,
                                                               dateStyle: .medium,
                                                               timeStyle: .none))
                                .fontWeight(.bold)
                        }
                    }
                } else {
                    HStack {
                        if lists.fetchContinueStrings(with: list.listNumber) != []{
                            Text("Дата окончания: ")
                            Spacer()
                            Text(DateFormatter.localizedString(
                                from: self.lists.fetchContinueStrings(with: list.listNumber).last!.endDate,
                                dateStyle: .medium,
                                timeStyle: .none
                            ))
                                .fontWeight(.bold)
                        } else {
                            Text("Дата окончания: ")
                            Spacer()
                            Text(DateFormatter.localizedString(from: self.list.endDate,
                                                               dateStyle: .medium,
                                                               timeStyle: .none))
                                .fontWeight(.bold)
                        }
                    }
                }
                HStack {
                    Spacer()
                    Text("Больше информации.")
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
        }
    .background(AngularGradient.init(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7500734925, green: 1, blue: 0.9300767779, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]),
                                     center: .bottom,
                     startAngle: .degrees(20),
                     endAngle: .degrees(20))
    .edgesIgnoringSafeArea(.all))
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
