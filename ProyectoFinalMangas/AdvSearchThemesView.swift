//
//  AdvSearchThemesView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 28/1/24.
//

import SwiftUI

struct AdvSearchThemesView: View {
    @Environment(AdvancedSearchMangasVM.self) var vm2
    @Environment(MangasVM.self) var vm
    @State private var navigateToDemographicsView = false
    @Binding var path: NavigationPath
    
    var body: some View {
        @Bindable var vmASM = vm2
        
        VStack {
            List(vm.themes, selection: $vmASM.searchSetThemes){
                Text("\($0.theme)")
            }
            .environment(\.editMode, .constant(EditMode.active))
            HStack {
                Spacer()
                Button("Pulse aquí para continuar") {
                    navigateToDemographicsView = true // Establece la navegación a true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            .navigationDestination(isPresented: $navigateToDemographicsView){
                AdvSearchDemographicsView(path: $path)
                    .environment(vm)
                    .environment(vm2)
            }
        }
        .navigationTitle("Temáticas")
        .onAppear(){
            if vm.themes.count == 0{
                getThemes()
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
    func getThemes(){
        Task{
            await vm.getThemes()
        }
    }
}

#Preview {
    NavigationStack{
        AdvSearchThemesView(path: .constant(NavigationPath()))
            .environment(MangasVM.test)
            .environment(AdvancedSearchMangasVM())
            .modelContainer(testModelContainer)
    }
}
