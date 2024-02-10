//
//  AdvSearchGenresView.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 22/1/24.
//

import SwiftUI

struct AdvSearchGenresView: View {
    @Environment(AdvancedSearchMangasVM.self) var vm2
    @Environment(MangasVM.self) var vm
    @State private var navigateToThemesView = false
    @Binding var path: NavigationPath
    
    var body: some View {
        @Bindable var vmASM = vm2
        VStack {
            List(vm.genres, selection: $vmASM.searchSetGenres){
                Text("\($0.genre)")
                
            }
            .environment(\.editMode, .constant(EditMode.active))
            HStack {
                Spacer()
                Button("Pulse aquí para continuar") {
                    navigateToThemesView = true // Establece la navegación a true
                }
                .padding()
                .background(Color.blue)//.opacity(0.3))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer()
            }
            .navigationDestination(isPresented: $navigateToThemesView){
                AdvSearchThemesView(path: $path)
                    .environment(vm)
                    .environment(vm2)
            }
        }
        .navigationTitle("Generos")
        .onAppear(){
            if vm.genres.count == 0{
                getGenres()
            }
        }
        .toolbar {
            if UIDevice.current.userInterfaceIdiom == .phone {
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
    func getGenres(){
        Task{
            await vm.getGenres()
        }
    }
}

#Preview {
    NavigationStack{
        AdvSearchGenresView(path: .constant(NavigationPath()))
            .environment(MangasVM.test)
            .environment(AdvancedSearchMangasVM())
            .modelContainer(testModelContainer)
    }
}
