//
//  AdvancedSearchView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 22/1/24.
//

import SwiftUI

struct AdvancedSearchView: View {
    @State var vm2 = AdvancedSearchMangasVM()
    @Environment(MangasVM.self) var vm
    @State private var navigateToGenresView = false
    @Binding var path: NavigationPath
    
    var body: some View {
        @Bindable var vmASM = vm2
        List {
            Section("Manga"){
                AdvancedSearchTextFieldView(label: "Título", text: $vmASM.searchTitle)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
            }
            Section("Autor") {
                AdvancedSearchTextFieldView(label: "Nombre", text: $vmASM.searchAuthorFirstName)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                AdvancedSearchTextFieldView(label: "Apellido", text: $vmASM.searchAuthorLastName)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
            }
            Section {
                HStack {
                    Spacer()
                    Button("Pulse aquí para continuar") {
                        navigateToGenresView = true // Establece la navegación a true
                    }
                    .padding()
                    .background(Color.blue)//.opacity(0.3))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            .navigationDestination(isPresented: $navigateToGenresView){
                AdvSearchGenresView(path: $path)
                    .environment(vm)
                    .environment(vm2)
            }
        }
        .navigationTitle("Busqueda Avançada")
        .onAppear(){
            Task{
                await vm.getGenres()
                await vm.getThemes()
                await vm.getDemographics()
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    path.removeLast()
                    vm2.cleanAdvSearchMangas()
                } label: {
                    Image(systemName: "eraser.line.dashed")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AdvancedSearchView(path: .constant(NavigationPath()))
            .environment(MangasVM.test)
            .environment(AdvancedSearchMangasVM())
            .modelContainer(testModelContainer)
    }
}
