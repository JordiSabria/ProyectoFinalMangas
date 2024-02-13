//
//  AdvancedSearchiPadView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 9/2/24.
//

import SwiftUI

struct AdvancedSearchiPadView: View {
    @State var vm2 = AdvancedSearchMangasVM()
    @Environment(MangasVM.self) var vm
    @State private var navigateToGenresView = false
    @State private var path = NavigationPath()
    
    var body: some View {
        @Bindable var vmASM = vm2
        NavigationStack(path: $path){
            List {
                Section("Manga"){
                    AdvancedSearchTextFieldView(label: "Título", text: $vmASM.searchTitle)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .hoverEffect()
                }
                Section("Autor") {
                    AdvancedSearchTextFieldView(label: "Nombre", text: $vmASM.searchAuthorFirstName)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .hoverEffect()
                    AdvancedSearchTextFieldView(label: "Apellido", text: $vmASM.searchAuthorLastName)
                        .textContentType(.name)
                        .textInputAutocapitalization(.words)
                        .hoverEffect()
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
                        .hoverEffect()
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
        }
        .navigationTitle("Busqueda Avançada")
        .onAppear(){
            Task{
                await vm.getGenres()
                await vm.getThemes()
                await vm.getDemographics()
            }
        }
    }
}

#Preview {
    AdvancedSearchiPadView()
        .environment(MangasVM.test)
        .environment(AdvancedSearchMangasVM())
        .modelContainer(testModelContainer)
}
