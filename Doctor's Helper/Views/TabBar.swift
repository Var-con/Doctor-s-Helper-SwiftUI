//
//  TabBar.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 18.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
            CalculatingView()
            StorageListView()
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}
