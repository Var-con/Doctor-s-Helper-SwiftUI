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
                Color.green.edgesIgnoringSafeArea(.all).blur(radius: 10).brightness(0.6)
                
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
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 3))
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
