//
//  TextFieldSaveButtonView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 19.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct TextFieldSaveButtonView: View {
    @State var listNumber = ""
    @State var savingAlert = false
    @State var showAlert = false
    var continueList: Bool = false
    @Binding var startValue: Date
    @Binding var endValue: Date
    @State var list: ListOfUnworking?
    
    var body: some View {
        HStack {
            TextField("Введите номер больничного", text: $listNumber)
                .padding(.leading, 20)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Ошибка ввода!"),
                        message: Text("День окончания листа нетрудоспособности установлен раньше дня начала листа нетрудоспособности! Введите правильную дату."),
                        dismissButton: .default(Text("Ok"))
                    )
            }
                    Button(action: {
                        
                        self.save()
                    }) {
                        Text("Сохранить")
                    }.alert(isPresented: $savingAlert) {
                        Alert(title: Text("Больничный успешно сохранен"))
                    }
            }.padding(.top, 20)
                .animation(.default)
        }
    }
    
    struct TextFieldSaveButtonView_Previews: PreviewProvider {
        static var previews: some View {
            TextFieldSaveButtonView(startValue: .constant(Date.init()), endValue: .constant(Date.init()))
        }
    }
    
    extension TextFieldSaveButtonView {
        private func save() {
            let resultDays = CalculatingService
                .shared
                .getDays(from: self.startValue, to: self.endValue)
            if resultDays == 0 {
                self.showAlert.toggle()
                return
            } else {
                var list = CalculatingService
                    .shared
                    .savingToStorage(
                        listNumber: self.listNumber,
                        startDate: self.startValue,
                        endDate: self.endValue
                )
                if self.continueList == true {
                    list.previoslyListNumber = self.list?.listNumber
                }
                StorageManager.shared.saveList(with: list)
                self.savingAlert.toggle()
            }
        }
}
