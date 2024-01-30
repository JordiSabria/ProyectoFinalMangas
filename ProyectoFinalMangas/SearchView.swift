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
    @Environment(\.modelContext) private var context
    
    var body: some View {
        NavigationStack(path: $path){
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
                NavigationLink(value: search.superSearch){
                    HStack{
                        Label("Búsqueda avançada", systemImage: "magnifyingglass")
                    }
                }
            }
            .navigationTitle("Búsqueda")
            .navigationDestination(for: search.self) { search in
                switch search {
                case .allMangas:
                    AllMangasView(path: $path)
                        .environment(vm)
                case .bestMangas:
                    BestMangasView(path: $path)
                        .environment(vm)
                case .authors:
                    AuthorsView(path: $path)
                        .environment(vm)
                case .demographics:
                    DemographicsView(path: $path)
                        .environment(vm)
                case .genres:
                    GenresView(path: $path)
                        .environment(vm)
                case .themes:
                    ThemesView(path: $path)
                        .environment(vm)
                case .superSearch:
                    AdvancedSearchView(path: $path)
                        .environment(vm)
                }
            }
        }
        .onAppear(){
            vm.estadoPantalla = .search
            print (URL.documentsDirectory)
        }
    }
}

#Preview {
    SearchView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
    
}
