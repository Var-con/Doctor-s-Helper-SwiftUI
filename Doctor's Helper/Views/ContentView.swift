//
//  ContentView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct ContentView: View {


    var body: some View {
        NavigationView {
            ZStack {
//                Color.green.edgesIgnoringSafeArea(.all).blur(radius: 10).brightness(0.6)
                AngularGradient.init(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.7500734925, green: 1, blue: 0.9300767779, alpha: 1)), Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))]), center: .bottomTrailing, startAngle: .zero, endAngle: .degrees(100)).edgesIgnoringSafeArea(.all)
                VStack {
                    Image("mainView").opacity(0.6)
                    Spacer()
                    NavigationLink(destination: CalculatingView( exitToPreviousPage: false)) {
                        Text("Рассчитать больничный лист")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 270, height: 100)
                    .modifier(CommonBlueButtonModifier())
                    
                    NavigationLink(destination: StorageListView()) {
                        Text("Сохраненные больничные листы")
                        Image(systemName: "folder")
                    }
                    .frame(width: 200, height: 70)
                .modifier(CommonWhiteButtonModifier())
                    .padding(.top, 20)
                    Spacer()
                }
                .navigationBarTitle("Doctor's Helper")
                
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
