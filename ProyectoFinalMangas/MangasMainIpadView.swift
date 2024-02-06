//
//  MangasMainIpadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 5/2/24.
//

import SwiftUI

struct MangasMainIpadView: View {
    @Environment(MangasVM.self) var vm
    @Environment(\.modelContext) private var context
    @State private var path = NavigationPath()
    var body: some View {
        TabView{
            AllMangasView()
                .environment(vm)
                .tabItem {
                    Label("Mangas", systemImage: "house")
                }
            BestMangaiPadView()
                .environment(vm)
                .tabItem{
                    Label("Mejores Mangas", systemImage: "hand.thumbsup")
                }
            AuthorsiPadView()
                .environment(vm)
                .tabItem{
                    Label("Autores", systemImage: "person")
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
    MangasMainIpadView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
