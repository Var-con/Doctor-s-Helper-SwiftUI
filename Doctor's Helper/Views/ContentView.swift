//
//  ContentView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var isActive = false
    @State var secondButtonActive = false
    var body: some View {
        NavigationView {
            ZStack{
                Color.green.edgesIgnoringSafeArea(.all).blur(radius: 10).brightness(0.6)
                
                VStack {
                    NavigationLink(destination: CalculatingView(), isActive: $isActive) {
                        Text("Рассчитать больничный лист")
                    }.frame(width: 250, height: 100)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.blue, lineWidth: 3))
                    
                    NavigationLink(destination: StorageListView(), isActive: $secondButtonActive) {
                        Text("Сохраненные больничные листы")
                        Image(systemName: "folder")
                        
                    }.padding(.top, 20)
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
