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
    @State var storedContinueLists: [ListOfUnworking] = []
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                SectionView(list: list, firstList: list, continueIsPresented: continueIsPresented, isActive: $isActive, storedContinueLists: $storedContinueLists)
                Spacer()
                VStack {
                    ForEach(self.storedContinueLists) { nextList in
                        if nextList.previoslyListNumber == self.list.listNumber {
                            Text("Лист продолжения:")
                            SectionView(list: nextList,
                                        firstList: self.list,
                                        continueIsPresented: self.continueIsPresented,
                                        isActive: self.$isActive,
                                        storedContinueLists: self.$storedContinueLists)
                        }
                    }
                }
                .animation(.default)
                
                Button(action: { self.isPresented.toggle() }) {
                    Text("Создать продолжение")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }.sheet(isPresented: $isPresented) {
                    ContinueList(list: self.list,
                                 showModal: self.$isPresented,
                                 date: self.list.endDate,
                                 resultText: "",
                                 storedContinueLists: self.$storedContinueLists)
                }
                    
                .frame(width: 200, height: 70)
                .modifier(CommonBlueButtonModifier())
                .padding(.top, 20)
                Spacer()
            }
            .padding()
        }
            .background(AngularGradient.init(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7500734925, green: 1, blue: 0.9300767779, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]), center: .bottomTrailing, startAngle: .zero, endAngle: .degrees(100)))
        .onAppear {
            self.storedContinueLists = self.lists.fetchListWithPrevioslyNumber()
            print(self.storedContinueLists)
        }
        
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

