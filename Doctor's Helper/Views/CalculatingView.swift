//
//  CalculatingView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct CalculatingView: View {
    @State var startDate: Date = Date()
    @State var endDate: Date = Date()
    @State private var resultText: String = ""
    @State private var showAlert = false
    @State private var showTextField = false
    @State private var listNumber = ""
    @State private var savingAlert = false
    
    var body: some View {
        ZStack {
            AngularGradient.init(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7500734925, green: 1, blue: 0.9300767779, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]),
                                 center: .bottomTrailing,
                                 startAngle: .zero,
                                 endAngle: .degrees(100))
            VStack {
                Spacer()
                VStack {
                    CalendarView(date: $startDate,
                                 text: "Начало нетрудоспособности")
                        .padding(.top, 5)
                    CalendarView(date: $endDate,
                                 text: "Окончание нетрудоспособности")
                        .padding(.top, 10)
                }
                .padding()
                .modifier(SectionModifier())
                Spacer()
                if showTextField {
                    TextFieldSaveButtonView(
                        listNumber: listNumber,
                        savingAlert: savingAlert,
                        showAlert: showAlert,
                        continueList: false,
                        startValue: $startDate,
                        endValue: $endDate,
                        exitToPreviousPage: .constant(false),
                        storedContinueLists: .constant([]))
                } else {
                    Spacer().frame(height: 34)
                }
                VStack {
                    Text(resultText)
                        .font(.headline)
                        .padding(.all, 10)
                    CalculateButtonView(startDate: $startDate, endDate: $endDate, resultText: $resultText)
                    
                    HStack {
                        Button(action: {
                            self.showTextField.toggle()
                        }) {
                            Text("Сохранить лист нетрудоспособности").font(.footnote)
                        }
                        .frame(width: 170, height: 50)
                        .modifier(CommonWhiteButtonModifier())
                        
                        Button(action: {
                            self.restoreToDefault()
                        }) {
                            Text("Очистить")
                        }.frame(width: 100, height: 50)
                        .modifier(CommonRejectButton())
                    }.padding(.top, 10)
                    Spacer().frame(height: 20)
                }
                .animation(.default)
            }
            .navigationBarTitle("Рассчитайте больничный", displayMode: .inline)
        }
    }
}

struct CalculatingView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatingView(startDate: Date.init(), endDate: Date.init())
    }
}

extension CalculatingView {

    private func restoreToDefault() {
        resultText = ""
        startDate = .init()
        endDate = .init()
        showTextField = false
        savingAlert = false
    }
}
