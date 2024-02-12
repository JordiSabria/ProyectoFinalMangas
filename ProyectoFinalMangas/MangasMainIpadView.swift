//
//  MangasMainIpadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 5/2/24.
//

import SwiftUI

struct MangasMainIpadView: View {
    @Environment(MangasVM.self) var vm
    //@Environment(\.modelContext) private var context
    //@State private var path = NavigationPath()
    var body: some View {
        TabView{
//            AllMangasView()
//                .environment(vm)
//                .tabItem {
//                    Label("Mangas", systemImage: "house")
//                }
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
            DemographicsiPadView()
                .environment(vm)
                .tabItem{
                    Label("Demográficas", systemImage: "person.3")
                }
            GenresiPadView()
                .environment(vm)
                .tabItem{
                    Label("Géneros", systemImage: "theatermasks")
                }
            ThemesiPadView()
                .environment(vm)
                .tabItem{
                    Label("Temáticas", systemImage: "figure.martial.arts")
                }
            AdvancedSearchiPadView()
                .environment(vm)
                .tabItem{
                    Label("Búsqueda avançada", systemImage: "magnifyingglass")
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
        //.modelContainer(testModelContainer)
}
