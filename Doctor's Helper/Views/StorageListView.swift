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
                Text("\(list.listNumber)")
                
            }
        }
    .navigationBarTitle("Ваши сохраненные больничные!")
    }
}

struct StorageListView_Previews: PreviewProvider {
    static var previews: some View {
        StorageListView()
    }
}
