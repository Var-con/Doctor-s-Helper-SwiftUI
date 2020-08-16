//
//  CalculatingView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct CalculatingView: View {
    @State var startValue: Date = .init()
    @State var endValue: Date = .init()
    @State var resultText: String = ""
    @State var showAlert = false
    @State var showTextField = false
    @State var listNumber = ""
    @State var savingAlert = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                HStack {
                    CalendarView(date: $startValue, text: "Начало нетрудоспособности")
                    Spacer()
                }
                .padding(.top, 20)
                HStack {
                    CalendarView(date: $endValue, text: "Окончание нетрудоспособности")
                    Spacer()
                }
                .padding(.top, 40)
                Spacer()
                if showTextField {
                    HStack {
                        TextField("Введите номер больничного листа...", text: $listNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            let targetValue = DateInterval(start: self.startValue, end: self.endValue)
                            let resultDays = lround(targetValue.duration / 86400) + 1
                            
                            let listOfUnworking = self.savingListData(
                                from: self.startValue,
                                endDay: self.endValue,
                                totalDays: resultDays,
                                listNumber: self.listNumber
                            )
                            StorageManager.shared.saveList(with: listOfUnworking)
                            self.restoreToDefault()
                            self.savingAlert.toggle()
                        }) {
                            Text("Сохранить")
                        }.alert(isPresented: $savingAlert) {
                            Alert(title: Text("Лист нетрудоспособности успешно сохранен"))
                        }
                    }.frame(height: 100)
                } else { Spacer().frame(height: 100) }
                Spacer()
                Text(resultText)
                    .padding(.bottom, 20)
                    .padding(.top, 20)
                    .font(.headline)
                Button(action: { self.getDays() }) {
                    Text("Рассчитать!")
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Ошибка ввода!"),
                        message: Text("День окончания листа нетрудоспособности установлен раньше дня начала листа нетрудоспособности! Введите правильную дату."),
                        dismissButton: .default(Text("Ok"))
                    )
                }
                .frame(width: 200, height: 70)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 3)
                )
                HStack {
                    Button(action: {
                        self.showTextField.toggle()
                    }) {
                        Text("Сохранить лист нетрудоспособности").font(.footnote)
                    }
                    .frame(width: 150)
                    
                    Button(action: {
                        self.restoreToDefault()
                    }) {
                        Text("Очистить")
                    }.frame(width: 100)
                }.padding(.top, 20)
                Spacer()
            }
            .padding()
        }
        .background(Color.green.edgesIgnoringSafeArea(.all).blur(radius: 10).brightness(0.6))
        .navigationBarTitle("Рассчитайте больничный", displayMode: .inline)
    }
}

struct CalculatingView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatingView()
    }
}

extension CalculatingView {
    private func getDays() {
        let compareResult = self.startValue.compare(self.endValue)
        guard compareResult.rawValue <= 0 else {
            self.showAlert = true
            return
        }
        let targetValue = DateInterval(start: self.startValue, end: self.endValue)
        let resultDays = lround(targetValue.duration / 86400) + 1
        self.resultText = "\(resultDays) суток нетрудоспособности."
    }
    
    private func restoreToDefault() {
        resultText = ""
        startValue = .init()
        endValue = .init()
        self.showTextField = false
    }
    
    private func savingListData(from startDay: Date, endDay: Date, totalDays: Int, listNumber: String) -> ListOfUnworking {
        return ListOfUnworking(id: Int(listNumber)!, listNumber: listNumber,
                               totalDays: totalDays,
                               startDate: startDay,
                               endDate: endDay)
    }
}
