//
//  SearchView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 10/1/24.
//

import SwiftUI

struct SearchView: View {
    @Environment(MangasVM.self) var vm
    
    var body: some View {
        NavigationStack{
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
                        Label("Demografías", systemImage: "person")
                    }
                }
                NavigationLink(value: search.genres) {
                    HStack{
                        Label("Géneros", systemImage: "hand.thumbsup")
                    }
                }
                NavigationLink(value: search.themes) {
                    HStack{
                        Label("Temáticas", systemImage: "hand.thumbsup")
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
                    AllMangasView()
                        .environment(vm)
                case .authors:
                    AllMangasView()
                        .environment(vm)
                case .demographics:
                    AllMangasView()
                        .environment(vm)
                case .genres:
                    AllMangasView()
                        .environment(vm)
                case .themes:
                    AllMangasView()
                        .environment(vm)
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environment(MangasVM())
}
