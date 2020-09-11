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
    @Binding var returnToPreviousScreen: Bool
    @State var storedContinueStrings: [ContinueListWithoutNumber] = []
    @State var storedContinueLists: [ListOfUnworking] = []
    @State private var returnTiPreviousScreenFromCalculateScreen = false
    @ObservedObject private var fetchingListManager = ListsOfUnworking()
    @State private var continueIsPresented = false
    @State private var showAskingOfDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                SectionView(list: list, firstList: list, continueIsPresented: continueIsPresented, isActive: $returnToPreviousScreen, storedContinueLists: $storedContinueLists)
                Spacer()
                VStack {
                    ForEach(self.takeContinueLists()){ nextList in
                                Text("Лист продолжения:")
                                .font(.title)
                                .fontWeight(.bold)
                            SectionView(list: nextList,
                                        firstList: self.list,
                                        continueIsPresented: self.continueIsPresented,
                                        isActive: self.$returnToPreviousScreen,
                                        storedContinueLists: self.$storedContinueLists)
                    }
                }
                .animation(.default)
                
                Button(action: { self.returnTiPreviousScreenFromCalculateScreen.toggle() }) {
                    Text("Создать продолжение")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }.sheet(isPresented: $returnTiPreviousScreenFromCalculateScreen) {
                    ContinueList(list: self.list,
                                 showModal: self.$returnTiPreviousScreenFromCalculateScreen,
                                 date: self.list.endDate,
                                 resultText: "",
                                 storedContinueLists: self.$storedContinueLists
                    )
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
            self.storedContinueLists = self.fetchingListManager.fetchListWithPrevioslyNumber()
        }
        
}
}
struct DeatailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        DeatailInfoView(list: ListOfUnworking(id: "12",
                                              listNumber: "12",
                                              totalDays: 2,
                                              startDate: Date(),
                                              endDate: Date()),
                        returnToPreviousScreen: .constant(false))
    }
}



extension DeatailInfoView {
    private func takeContinueLists() -> [ListOfUnworking] {
        var arrayOfNextLists: [ListOfUnworking] = []
        for nextList in self.storedContinueLists {
            if nextList.previoslyListNumber == self.list.listNumber {
                arrayOfNextLists.append(nextList)
            }
        }
        print(arrayOfNextLists)
        return arrayOfNextLists
    }
}
