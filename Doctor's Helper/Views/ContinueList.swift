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
    var body: some View {
        VStack {
            VStack {
                Text("Продолжение листа нетрудоспособности №\(list.listNumber)")
                
                CalendarView(date: $date , text: "Дата начала:")
                CalendarView(date: $endDate, text: "Дата окончания:")
                
                TextFieldSaveButtonView(listNumber: listNumber,
                                        savingAlert: savingAlert,
                                        showAlert: showAlert,
                                        continueList: true,
                                        startValue: $date,
                                        endValue: $endDate,
                                        list: list)
                
            }
            Button("Close") {
                self.showModal = false
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
            date: Date.init())
    }
}


