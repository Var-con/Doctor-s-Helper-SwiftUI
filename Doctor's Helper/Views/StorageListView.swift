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
    @State var listsForTable: [ListOfUnworking] = []
    @State var popover = false
    
    var body: some View {
            List (listsForTable, id: \.listNumber) { list in
                RowList(list: list)
                if self.listsForTable.isEmpty {
                    Text("Вы еще не добавляли своих больничных листов.")
                }
                }
    
            .navigationBarTitle("Ваши сохраненные больничные!", displayMode: .inline)
                .onAppear {
                    self.listsForTable = self.lists.fetchListWithoutPrevioslyNumber()
        }
            .listStyle(GroupedListStyle())
        }
    }
    
    struct StorageListView_Previews: PreviewProvider {
        static var previews: some View {
            StorageListView()
            
        }
}
