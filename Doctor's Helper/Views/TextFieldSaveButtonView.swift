//
//  TextFieldSaveButtonView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 19.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct TextFieldSaveButtonView: View {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @State var listNumber = ""
    @State var savingAlert = false
    @State var showAlert = false
    var continueList: Bool = false
    @Binding var startValue: Date
    @Binding var endValue: Date
    @State var list: ListOfUnworking?
    @Binding var exitToPreviousPage: Bool
    @State var showRewrightListNumber = false
    @Binding var storedContinueLists: [ListOfUnworking]
    @ObservedObject var lists = ListsOfUnworking()
    
    var body: some View {
        HStack {
            TextField("Номер больничного", text: $listNumber)
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
            }
            .frame(width: 100, height: 40)
                .modifier(CommonWhiteButtonModifier())
            .alert(isPresented: $savingAlert) {
                
                return Alert(title: Text("Сохранено"),
                             message: Text("Больничный успешно сохранен"),
                             dismissButton: .default(Text("Ok"),
                                                     action: {
                                                        self.exitToPreviousPage.toggle()
                             }))
            }
            Spacer().alert(isPresented: $showRewrightListNumber) {
                Alert(title: Text("Ошибка"),
                      message: Text("Номер больничного листа не уникален"),
                      dismissButton: .default(Text("Ok")))
            }
        }
            
        .padding(.all, 10)
        .animation(.default)
    }
}

struct TextFieldSaveButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldSaveButtonView(startValue: .constant(Date.init()), endValue: .constant(Date.init()), exitToPreviousPage: .constant(false),
                                storedContinueLists: .constant([])
        )
    }
}

extension TextFieldSaveButtonView {
    private func save() {
        let resultDays = CalculatingService
            .shared
            .getDays(from: self.startValue, to: self.endValue)
        guard resultDays > 0 else {
            self.showAlert.toggle()
            return
        }
        var list = CalculatingService
            .shared
            .savingToStorage(
                listNumber: self.listNumber,
                startDate: self.startValue,
                endDate: self.endValue
        )
        if self.continueList {
            list.previoslyListNumber = self.list?.listNumber
        }
        let uniqLists = StorageManager.shared.fetchLists()
        for uniqList in uniqLists {
            guard uniqList.listNumber != list.listNumber else {
                showRewrightListNumber.toggle()
                return
                
            }
        }
        appDelegate?.scheduleNotification(with: list)
        self.savingAlert.toggle()
        StorageManager.shared.saveList(with: list)
        self.storedContinueLists = self.lists.fetchListWithPrevioslyNumber()
    }
}
