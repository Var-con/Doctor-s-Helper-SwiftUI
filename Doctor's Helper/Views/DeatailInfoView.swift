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
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @State private var isPresented = false
    @ObservedObject private var lists = ListsOfUnworking()
    @Binding var isActive: Bool
    @State private var continueIsPresented = false
    
    @State private var showAskingOfDeleteAlert = false
    @State var stringsCount: [ContinueListWithoutNumber] = []
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                SectionView(list: list, continueIsPresented: continueIsPresented, isActive: $isActive)
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
                                        Text(DateFormatter.localizedString(from: nextList.startDate,
                                                                           dateStyle: .medium,
                                                                           timeStyle: .none))
                                            .fontWeight(.bold)
                                    }
                                    HStack {
                                        Text("Дата окончания нетрудоспособности: ")
                                        Spacer()
                                        Text(DateFormatter.localizedString(from: nextList.endDate,
                                                                           dateStyle: .medium,
                                                                           timeStyle: .none))
                                            .fontWeight(.bold)
                                    }
                                    Text("Всего дней: \(self.list.totalDays + nextList.totalDays)")
                                    HStack {
                                        Spacer()
                                        Button( action: {
                                            self.showAskingOfDeleteAlert.toggle()
                                        }) {
                                            Text("Удалить").fontWeight(.bold)
                                        }
                                        .frame(width: 100, height: 30)
                                        .modifier(DeleteButtonModifier())
                                        .alert(isPresented: self.$showAskingOfDeleteAlert) {
                                            Alert(title: Text("Вы точно хотите удалить л/н?"),
                                                  primaryButton: Alert.Button.destructive(Text("Да"), action: {
                                                    self.deleteList(list: nextList)
                                                  }),
                                                  secondaryButton: Alert.Button.cancel())
                                        }
                                    }
                                }
                                .padding()
                                .modifier(SectionModifier())
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
                    ContinueList(list: self.list,
                                 showModal: self.$isPresented,
                                 date: self.list.endDate,
                                 resultText: "")
                }
                .frame(width: 200, height: 70)
                .modifier(CommonBlueButtonModifier())
                .padding(.top, 20)
                Spacer()
            }
                
            .padding()
        }
            .background(AngularGradient.init(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7500734925, green: 1, blue: 0.9300767779, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]), center: .bottomTrailing, startAngle: .zero, endAngle: .degrees(100)))
        
}
}
struct DeatailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeatailInfoView(list: ListOfUnworking(id: 12,
                                              listNumber: "12",
                                              totalDays: 2,
                                              startDate: Date(),
                                              endDate: Date()),
                        isActive: .constant(false))
    }
}


extension DeatailInfoView {
    
    func deleteList(list: ListOfUnworking) {
        var listsArray = lists.fetchLists()
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

//struct SectionView: View {
//    
//    @State var list: ListOfUnworking
//    @State var continueIsPresented: Bool
//    @State var lists: [ContinueListWithoutNumber] = []
//    @State var showAskingOfDeleteAlert: Bool = false
//    @State var action: () -> Void
//    var body: some View {
//        
//        VStack {
//            VStack {
//                Text("Лист нетрудоспособности: № ")
//                Text("\(list.listNumber)")
//                    .fontWeight(.bold)
//            }
//            HStack {
//                Text("Дата начала нетрудоспособности: ")
//                Spacer()
//                Text(DateFormatter.localizedString(from: list.startDate,
//                                                   dateStyle: .medium,
//                                                   timeStyle: .none))
//                    .fontWeight(.bold)
//            }
//            HStack {
//                Text("Дата окончания нетрудоспособности: ")
//                Spacer()
//                Text(DateFormatter.localizedString(from: list.endDate,
//                                                   dateStyle: .medium,
//                                                   timeStyle: .none))
//                    .fontWeight(.bold)
//            }
//            HStack {
//                if lists.count < 2 {
//                    Button(action: {
//                        self.continueIsPresented.toggle()
//                    }) {
//                        Text("Продлить")
//                    }.sheet(isPresented: $continueIsPresented) {
//                        ContinueWithStringCalculate(list: self.list,
//                                                    showModal: self.$continueIsPresented,
//                                                    date: self.list.endDate)
//                    }
//                }
//                
//                
//                Spacer()
//                Button( action: {
//                    self.showAskingOfDeleteAlert.toggle()
//                }) {
//                    Text("Удалить").fontWeight(.bold)
//                }
//                .frame(width: 100, height: 30)
//                .modifier(DeleteButtonModifier())
//            }
//            .alert(isPresented: self.$showAskingOfDeleteAlert) {
//                Alert(title: Text("Вы точно хотите удалить л/н?"),
//                      primaryButton: Alert.Button.destructive(Text("Да"), action: {
//                        self.action()
//                      }),
//                      secondaryButton: Alert.Button.cancel())
//            }
//        }
//        .onAppear {
////            self.stringsCount = self.$lists.fetchContinueStrings(with: self.list.listNumber)
//        }
//        .padding()
//        .modifier(SectionModifier())
//        .padding(.top, 20)
//    }
//}

// добавить экшен и вывесты блок л/н в отдельный файл

