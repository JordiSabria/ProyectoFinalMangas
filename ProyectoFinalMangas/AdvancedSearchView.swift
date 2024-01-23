//
//  AdvancedSearchView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 22/1/24.
//

import SwiftUI

struct AdvancedSearchView: View {
    @State var vmASM = AdvancedSearchMangasVM()
    @Environment(MangasVM.self) var vm
    var body: some View {
        @Bindable var vm2 = vmASM
        Form{
            Section{
                AdvancedSearchTextFieldView(label: "Título", text: $vmASM.searchTitle)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
            } header: {
                Text("Manga")
            }
            Section {
                AdvancedSearchTextFieldView(label: "Nombre", text: $vmASM.searchAuthorFirstName)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
                AdvancedSearchTextFieldView(label: "Apellido", text: $vmASM.searchAuthorLastName)
                    .textContentType(.name)
                    .textInputAutocapitalization(.words)
            } header: {
                Text("Autor")
            }
        }
        NavigationLink(value:vmASM.searchAuthorFirstName){
            Text("Pulse aquí para continuar")
//            Button("Pulse aquí para continuar") {
//            }
//            .buttonStyle(.bordered)
//            .buttonBorderShape(.capsule)
        }
        .navigationTitle("Busqueda Avançada")
        .navigationDestination(for: String.self){ nombre in 
            //AdvSearchGenresView(vmASM: $vmASM)
        }
        
//            List(vm.genres.map{$0.genre}, id: \.self, selection: $vmASM.searchSetGenres){
//                Text("\($0)")
//            }
//            
//            .environment(\.editMode, .constant(EditMode.active))
//            List(vm.themes.map{$0.theme}, id: \.self, selection: $vmASM.searchSetThemes){
//                Text("\($0)")
//            }
//            .environment(\.editMode, .constant(EditMode.active))
//            List(vm.demographics.map{$0.demographic}, id: \.self, selection: $vmASM.searchSetDemographics){
//                Text("\($0)")
//            }
//            .environment(\.editMode, .constant(EditMode.active))
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
    NavigationStack {
        AdvancedSearchView()
            .environment(MangasVM.test)
    }
}
