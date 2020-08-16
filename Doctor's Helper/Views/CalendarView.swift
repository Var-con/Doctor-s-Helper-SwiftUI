//
//  Calendar.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI


struct CalendarView: View {
    @Binding var date: Date
    @State var showCalendar: Bool = false
    var text: String
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("\(text)")
                        .frame(width: 200)
                        .font(.body).scaledToFill().multilineTextAlignment(.center)
                    Text("\(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none))")
                    Spacer()
                }
                Button(action: {
                    withAnimation {
                        self.showCalendar.toggle()
                    }
                }) {
                    HStack {
                        if showCalendar {
                            Text("Скрыть календарь")
                                .transition(.scale)
                        } else {
                            Text("Показать календарь")
                                .transition(.scale)
                        }
                        Image(systemName: "chevron.up.square")
                            .scaleEffect(showCalendar ? 1.5 : 1)
                            .rotationEffect(.degrees(showCalendar ? 0 : 180))
                            .animation(.default)
                    }
                }
                
                if showCalendar {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .frame(width: 200, height: 150)
                        .scaleEffect(0.9)
                        .padding(.trailing, 20)
                    
                }
            }
        }
    }
}


struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(date: .constant(.init()), text: "Окончание нетрудоспособности:")
    }
}
