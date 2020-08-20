//
//  CalculateButtonView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 19.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct CalculateButtonView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var resultText: String
    @State private var showAlert = false
    var body: some View {
        Button(action: {
            guard (self.endDate + 1) >= self.startDate else {
                self.showAlert.toggle()
                return
            }
            let resultDays = CalculatingService.shared.getDays(from: self.startDate, to: self.endDate)
                self.resultText = "\(resultDays) суток нетрудоспособности."
        }) {
            Text("Рассчитать!")
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Ошибка ввода!"),
                message: Text("День окончания листа нетрудоспособности установлен раньше дня начала листа нетрудоспособности! Введите правильную дату."),
                dismissButton: .default(Text("Ok"))
            )
        }
        .animation(.linear)
        .frame(width: 200, height: 50)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 3)
        )
    }
}

struct CalculateButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CalculateButtonView(startDate: .constant(Date()), endDate: .constant(Date()), resultText: .constant(""))
    }
}
