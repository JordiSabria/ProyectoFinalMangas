//
//  AuthorsView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 16/1/24.
//

import SwiftUI

struct AuthorsView: View {
    @Environment(MangasVM.self) var vm
    
    var body: some View {
        List(vm.authors){ author in
            NavigationLink(value: author){
                Text("\(author.firstName) \(author.lastName)")
            }
        }
        .navigationTitle("Autores")
        .navigationDestination(for: DTOAuthor.self){ author in
            MangasByAuthorView(author: author)
                .environment(vm)
        }
        .refreshable {
            Task{
                await vm.getAuthors()
            }
        }
        .onAppear(){
            switch vm.estadoPantalla{
                case .search:
                    vm.estadoPantalla = .authors
                    Task{
                        await vm.getAuthors()
                    }
                default:
                    vm.estadoPantalla = .authors
            }
        }
    }
}

#Preview {
    NavigationStack {
        AuthorsView()
            .environment(MangasVM.test)
    }
}
