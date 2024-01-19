//
//  SearchView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 10/1/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(MangasVM.self) var vm
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            Text(String(vm.mangasItemsArray.count))
            List{
                NavigationLink(value: search.allMangas) {
                    HStack{
                        Label("Todos los Mangas", systemImage: "book")
                    }
                }
                NavigationLink(value: search.bestMangas) {
                    HStack{
                        Label("Los mejores Mangas", systemImage: "hand.thumbsup")
                    }
                }
                NavigationLink(value: search.authors) {
                    HStack{
                        Label("Autores", systemImage: "person")
                    }
                }
                NavigationLink(value: search.demographics) {
                    HStack{
                        Label("Demográficas", systemImage: "person.3")
                    }
                }
                NavigationLink(value: search.genres) {
                    HStack{
                        Label("Géneros", systemImage: "theatermasks")
                    }
                }
                NavigationLink(value: search.themes) {
                    HStack{
                        Label("Temáticas", systemImage: "figure.martial.arts")
                    }
                }
            }
            .navigationTitle("Búsqueda")
            .navigationDestination(for: search.self) { search in
                switch search {
                case .allMangas:
                    AllMangasView()
                        .environment(vm)
                case .bestMangas:
                    BestMangasView()
                        .environment(vm)
                case .authors:
                    AuthorsView()
                        .environment(vm)
                case .demographics:
                    DemographicsView()
                        .environment(vm)
                case .genres:
                    GenresView()
                        .environment(vm)
                case .themes:
                    ThemesView()
                        .environment(vm)
                }
            }
        }
        .onAppear(){
            vm.estadoPantalla = .search
        }
    }
}

#Preview {
    SearchView()
        .environment(MangasVM.test)
}
