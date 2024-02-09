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
    @State var loading = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        @Bindable var bVM = vm
        if loading {
            ProgressView()
                .controlSize(.regular)
                .tint(colorScheme == .dark ? .white : .black)
        }
        List(vm.getAuthorsSearch()){ author in
            NavigationLink(value: author){
                Text("\(author.firstName) \(author.lastName)")
            }
        }
        .opacity(loading ? 0.0 : 1.0)
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
                    loading = true
                    await vm.getAuthors()
                    loading = false
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
