//
//  StorageListView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct StorageListView: View {

    @ObservedObject private var lists = ListsOfUnworking()
    
    var body: some View {
        List ((lists.fetchListWithoutPrevioslyNumber()), id: \.listNumber) { list in
                RowList(list: list)
        }
        .navigationBarTitle("Ваши сохраненные больничные!", displayMode: .inline)
    }
}

struct StorageListView_Previews: PreviewProvider {
    static var previews: some View {
        StorageListView()
        
    }
}
