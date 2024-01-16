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
        Text(String(vm.authors.count))
        List(vm.authors){ author in
            Text("\(author.firstName) \(author.lastName)")
        }
        .navigationTitle("Autores")
        .onAppear(){
            if vm.authors.count == 0 {
                Task{
                    await vm.getAuthors()
                }
            }
        }
    }
}

#Preview {
    AuthorsView()
        .environment(MangasVM())
}
