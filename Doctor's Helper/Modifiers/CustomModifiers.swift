//
//  CustomModifiers.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 22.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct SectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 3))
            .shadow(radius: 3)
        
    }
    
}

struct DeleteButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.init(red: 1, green: 0, blue: 0))
            .foregroundColor(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 2))
            .shadow(radius: 3)
    }
}

struct CommonBlueButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.green, lineWidth: 3))
            .shadow(radius: 2)
    }
}
    
    struct CommonWhiteButtonModifier: ViewModifier {
        func body(content: Content) -> some View {
            content
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 3))
                .shadow(radius: 2)
        }
        
}

struct CommonRejectButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.red)
            .foregroundColor(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20)
                .stroke(Color.blue, lineWidth: 2))
            .shadow(radius: 3)
    }
}
    
    struct CustomModifiers_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/.modifier(DeleteButtonModifier())
                /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/.modifier(CommonWhiteButtonModifier())
            }
        }
}
