//
//  AuthorsiPadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 5/2/24.
//

import SwiftUI

struct AuthorsiPadView: View {
    @Environment(MangasVM.self) var vm
    @State private var path = NavigationPath()
    @State var visibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        @Bindable var bVM = vm
        NavigationSplitView(columnVisibility: $visibility){
            List(vm.getAuthorsSearch()){ author in
                NavigationLink(value: author){
                    Text("\(author.firstName) \(author.lastName)")
                }
            }
            .navigationTitle("Autores")
            .navigationDestination(for: DTOAuthor.self){ author in
                MangasByAuthorView(author: author, path: $path)
                    .environment(vm)
            }
            .searchable(text: $bVM.searchAuthors, prompt: "Buscar un autor")
            .refreshable {
                Task{
                    await vm.getAuthors()
                }
            }
        } content: {
            if let authorTmp = vm.authors.first{
                MangasByAuthorView(author: authorTmp, path: $path)
                    .environment(vm)
            }
        } detail: {
            if let authorTmp = vm.authors.first{
                if let mangaTmp = vm.getFirstMangaBy(mangasbyToSord: .byAuthor, idAuthor: authorTmp.id, demographic: "", genre: "", theme: ""){
                    MangaDetailView(manga: mangaTmp, path: $path)
                        .environment(vm)
                }
            }
        }
        .onAppear(){
            vm.estadoPantalla = .authors
            if vm.authors.count == 0{
                Task{
                    await vm.getAuthors()
                }
            }
        }
    }
}

#Preview {
    AuthorsiPadView()
        .environment(MangasVM.test)
        .modelContainer(testModelContainer)
}
