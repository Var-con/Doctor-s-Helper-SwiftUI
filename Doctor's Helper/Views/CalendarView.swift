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
    @State private var showCalendar: Bool = false
    var text: String
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.showCalendar.toggle()
                }
            }) {
                HStack {
                    if showCalendar {
                        HStack {
                            Image(systemName: "calendar.circle.fill")
                            Text(text)
                                .fontWeight(.light)
                                .transition(.scale)
                        }
                    } else {
                        HStack {
                            Image(systemName: "calendar.circle")
                            Text(text)
                                .transition(.scale)
                            .frame(width: 200)
                            Text("\(DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none))")
                                .frame(width: 70)
                        }.frame(height: 70)
                    }
                    Image(systemName: "chevron.up.square")
                        .scaleEffect(showCalendar ? 1.5 : 1)
                        .rotationEffect(.degrees(showCalendar ? 0 : 180))
                        .animation(.default)
                }
            }
            
            if showCalendar {
                    DatePicker("", selection: $date, displayedComponents: .date)
                        .frame(width: 200, height: 80)
                        .padding(.top, 40)
                        .scaleEffect(0.7)
                
            }
        }
    }
}


struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(date: .constant(.init()), text: "Окончание нетрудоспособности:")
    }
}
