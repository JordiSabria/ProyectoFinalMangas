//
//  AuthorsView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI

struct AuthorsView: View {
    @Environment(MangasVM.self) var vm
    @Binding var path: NavigationPath
    
    var body: some View {
        @Bindable var bVM = vm
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
    NavigationStack {
        AuthorsView(path: .constant(NavigationPath()))
            .environment(MangasVM.test)
    }
}
