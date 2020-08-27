//
//  StorageListView.swift
//  Doctor's Helper
//
//  Created by Станислав Климов on 11.08.2020.
//  Copyright © 2020 Stanislav Klimov. All rights reserved.
//

import SwiftUI

struct StorageListView: View {

    @ObservedObject private var fetchingListsManager = ListsOfUnworking()
    @State var listsForTable: [ListOfUnworking] = []
    
    var body: some View {
            List (listsForTable, id: \.listNumber) { list in
                RowList(list: list)
                }
            .navigationBarTitle("Ваши сохраненные больничные!", displayMode: .inline)
                .onAppear {
                    self.listsForTable = self.fetchingListsManager.fetchListWithoutPrevioslyNumber()
        }
            .listStyle(GroupedListStyle())
        }
    }
    
    struct StorageListView_Previews: PreviewProvider {
        static var previews: some View {
            StorageListView()
            
        }
}
