//
//  StorageListView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct StorageListView: View {
    var lists = StorageManager.shared.fetchLists()
    var body: some View {
        List {
            ForEach(lists) { list in
                ZStack {
                    if list.endDate > Date.init() {
                    Color.green.brightness(0.6).blur(radius: 20)
                    } else {
                    Color.red.brightness(0.6).blur(radius: 20)
                    }
                    VStack {
                        Text("Номер листа: \(list.listNumber)")
                        Spacer()
                        HStack {
                            Text("Начало :")
                            Spacer()
                            Text(DateFormatter.localizedString(from: list.startDate, dateStyle: .medium, timeStyle: .none))
                        }
                        HStack {
                            Text("Окончание :")
                            Spacer()
                            Text(DateFormatter.localizedString(from: list.endDate, dateStyle: .medium, timeStyle: .none))
                        }
                        Text("Всего дней: \(list.totalDays)")
                        Spacer()
                    }
                }
            }
        }

        .navigationBarTitle("Ваши сохраненные больничные!", displayMode: .inline)
    }
}

struct StorageListView_Previews: PreviewProvider {
    static var previews: some View {
        StorageListView()
        
    }
}
