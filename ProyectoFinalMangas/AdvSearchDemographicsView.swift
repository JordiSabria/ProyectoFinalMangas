//
//  AdvSearchDemographicsView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 28/1/24.
//

import SwiftUI

struct AdvSearchDemographicsView: View {
    @Environment(AdvancedSearchMangasVM.self) var vm2
    @Environment(MangasVM.self) var vm
    @State private var navigateToMangasView = false
    @Binding var path: NavigationPath
    
    var body: some View {
        @Bindable var vmASM = vm2
        
        VStack {
            List(vm.demographics, selection: $vmASM.searchSetDemographics){
                Text("\($0.demographic)")
            }
            .environment(\.editMode, .constant(EditMode.active))
            HStack {
                Spacer()
                Button("Pulse aquí para Buscar los mangas") {
                    navigateToMangasView = true // Establece la navegación a true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            .navigationDestination(isPresented: $navigateToMangasView){
                AdvSearchMangasView(path: $path)
                    .environment(vm)
                    .environment(vm2)
            }
        }
        .navigationTitle("Demográficas")
        .onAppear(){
            vm.estadoPantalla = .advSearch
            if vm.demographics.count == 0{
                getDemographics()
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
    func getDemographics(){
        Task{
            await vm.getDemographics()
        }
    }
}

#Preview {
    NavigationStack{
        AdvSearchDemographicsView(path: .constant(NavigationPath()))
            .environment(MangasVM.test)
            .environment(AdvancedSearchMangasVM())
            .modelContainer(testModelContainer)
    }
}
