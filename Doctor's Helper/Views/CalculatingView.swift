//
//  CalculatingView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct CalculatingView: View {
    @State var startValue: Date = Date.init()
    @State var endValue: Date = Date.init()
    @State private var resultText: String = ""
    @State private var showAlert = false
    @State private var showTextField = false
    @State private var listNumber = ""
    @State private var savingAlert = false
    @State var exitToPreviousPage: Bool
    
    var body: some View {
        ZStack {
            Color.green.edgesIgnoringSafeArea(.all).blur(radius: 10).brightness(0.6)
            VStack {
                Spacer()
                VStack {
                    CalendarView(date: $startValue,
                                 text: "Начало нетрудоспособности")
                        .padding(.top, 5)
                    CalendarView(date: $endValue,
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
                        startValue: $startValue,
                        endValue: $endValue,
                        exitToPreviousPage: $exitToPreviousPage)
                } else {
                    Spacer().frame(height: 34)
                }
                VStack {
                    Text(resultText)
                        .font(.headline)
                        .padding(.all, 10)
                    CalculateButtonView(startDate: $startValue, endDate: $endValue, resultText: $resultText)
                    
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
        CalculatingView(startValue: Date.init(), endValue: Date.init(), exitToPreviousPage: false)
    }
}

extension CalculatingView {

    private func restoreToDefault() {
        resultText = ""
        startValue = .init()
        endValue = .init()
        showTextField = false
        savingAlert = false
    }
}
