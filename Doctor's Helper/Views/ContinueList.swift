//
//  ContinueList.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 19.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct ContinueList: View {
    
    var list: ListOfUnworking
    @Binding var showModal: Bool
    @State var date: Date
    @State private var endDate: Date = Date()
    @State private var listNumber = ""
    @State private var savingAlert = false
    @State private var showAlert = false
    @State var resultText: String
    @Binding var storedContinueLists: [ListOfUnworking]
    
    var body: some View {
        ZStack {
            AngularGradient.init(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7500734925, green: 1, blue: 0.9300767779, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]), center: .bottomTrailing, startAngle: .zero, endAngle: .degrees(100))
            VStack {
                VStack {
                    VStack {
                        Text("Продолжение листа нетрудоспособности").frame(width: 325, height: 25).font(.footnote)
                        Text("№\(list.listNumber)").fontWeight(.semibold)
                        
                        CalendarView(date: $date , text: "Дата начала:")
                        CalendarView(date: $endDate, text: "Дата окончания:").padding(.top, 10)
                    }
                    .padding()
                    .modifier(SectionModifier())
                    TextFieldSaveButtonView(listNumber: listNumber,
                                            savingAlert: savingAlert,
                                            showAlert: showAlert,
                                            continueList: true,
                                            startValue: $date,
                                            endValue: $endDate,
                                            list: list,
                                            exitToPreviousPage: $showModal,
                                            storedContinueLists: $storedContinueLists)
                    
                }
                Text(resultText)
                .font(.headline)
                .padding(.bottom, 10)
                CalculateButtonView(startDate: $date,
                                    endDate: $endDate,
                                    resultText: $resultText)
                
                Button("Закрыть") {
                    self.showModal = false
                }
                .frame(width: 100, height: 30)
                .modifier(CommonRejectButton())
                .padding(.top, 15)
            }
        }
    }
}

struct ContinueList_Previews: PreviewProvider {
    static var previews: some View {
        ContinueList(
            list: ListOfUnworking(id: 12,
                                  listNumber: "12",
                                  totalDays: 2,
                                  startDate: Date.init(),
                                  endDate: Date.init()),
            showModal: .constant(true),
            date: Date.init(), resultText: "11111", storedContinueLists: .constant([]))
    }
}


