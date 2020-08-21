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
    }
}

struct CommonBlueButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
    content
        .background(Color.blue)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20)
        .stroke(Color.green, lineWidth: 3))
    }
    
}
