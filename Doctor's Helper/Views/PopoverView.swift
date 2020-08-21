//
//  PopoverView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 22.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct PopoverView: View {
    var body: some View {
        VStack {
            Text("Сожалеем").font(.title)
        Text("Но Вы еще не добавляли своих листов нетрудоспособности.")
            }.frame(width: 250, height: 250)
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView()
    }
}
