//
//  MangasMain.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 10/1/24.
//

import SwiftUI

struct MangasMain: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    
    var body: some View {
        TabView{
            AllMangasView()
                .environment(vm)
                .tabItem {
                    Label("Mangas", systemImage: "house")
                }
            SearchView()
                .environment(vm)
                .tabItem{
                    Label("Búsqueda", systemImage: "magnifyingglass")
                }
            OwnCollectionView()
                .environment(vm)
                .tabItem{
                    Label("Col-lección", systemImage: "books.vertical")
                }
        }
    }
}

#Preview {
    MangasMain()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
