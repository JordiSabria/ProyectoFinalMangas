//
//  ProyectoFinalMangasApp.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 3/1/24.
//

import SwiftUI

@main
struct ProyectoFinalMangasApp: App {
    @State var vm: MangasVM = MangasVM()
    
    var body: some Scene {
        WindowGroup {
            MangasMain()
                .environment(vm)
                .alert("App Alert",
                       isPresented: $vm.showAlert) {
                } message: {
                    Text(vm.msg)
                }
        }
    }
}
