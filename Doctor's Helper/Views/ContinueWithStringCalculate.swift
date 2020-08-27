//
//  ContinueWithStringCalculate.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 22.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct ContinueWithStringCalculate: View {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var list: ListOfUnworking
    @Binding var showModal: Bool
    @State var date: Date
    @State private var endDate: Date = Date()
    @State private var savingAlert = false
    @State private var showAlert = false
    @Binding var storedString: [ContinueListWithoutNumber]
    
    var body: some View {
        ZStack {
            AngularGradient.init(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7500734925, green: 1, blue: 0.9300767779, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]), center: .bottomTrailing, startAngle: .zero, endAngle: .degrees(100))
            VStack {
                VStack {
                    VStack {
                        Text("Продолжение листа нетрудоспособности")
                            .frame(width: 325, height: 25)
                            .font(.footnote)
                        Text("№\(list.listNumber)").fontWeight(.semibold)
                        
                        CalendarView(date: $date , text: "Дата начала:")
                        CalendarView(date: $endDate, text: "Дата окончания:").padding(.top, 10)
                    }
                    .padding()
                    .modifier(SectionModifier())
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Ошибка ввода!"),
                            message: Text("День окончания листа нетрудоспособности установлен раньше дня начала листа нетрудоспособности! Введите правильную дату."),
                            dismissButton: .default(Text("Ok"))
                        )
                    }
                    Button(action: {
                        
                        self.save()
                        self.storedString = StorageManager.shared.fetchListsString().filter { $0.listNumber == self.list.listNumber }
                    }) {
                        Text("Сохранить")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                    .frame(width: 200, height: 50)
                    .modifier(CommonBlueButtonModifier())
                    .padding(.top, 15)
                    .alert(isPresented: $savingAlert) {
                        
                        return Alert(title: Text("Сохранено"),
                                     message: Text("Больничный успешно сохранен"),
                                     dismissButton: .default(Text("Ok"),
                                                             action: {
                                                                self.showModal.toggle()
                                     }))
                    }
                    
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
}
struct ContinueWithStringCalculate_Previews: PreviewProvider {
    static var previews: some View {
        ContinueWithStringCalculate(
            list: ListOfUnworking(id: 12,
                                  listNumber: "12",
                                  totalDays: 2,
                                  startDate: Date.init(),
                                  endDate: Date.init()),
            showModal: .constant(true),
            date: Date.init(), storedString: .constant([]))
    }
}


extension ContinueWithStringCalculate {
    private func save() {
        var numberOfString: NumberOfContinueString = .second
        let resultDays = CalculatingService
            .shared
            .getDays(from: self.date, to: self.endDate)
        guard resultDays > 0 else {
            self.showAlert.toggle()
            return
        }
        let array = ListsOfUnworking()
        let arrayOfStrings = array.fetchContinueStrings(with: list.listNumber)
        if arrayOfStrings.count > 0 {
            numberOfString = .third
        }
        
        let listOfString = CalculatingService
            .shared
            .savingToStorageString(startDate: date,
                                   endDate: endDate,
                                   numbeOfString: numberOfString,
                                   listNumber: list.listNumber)
        
        
        self.savingAlert.toggle()
        StorageManager.shared.saveContinueListString(with: listOfString)
        
    }
}
