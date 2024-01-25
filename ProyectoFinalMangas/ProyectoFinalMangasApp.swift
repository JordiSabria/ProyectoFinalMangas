//
//  ProyectoFinalMangasApp.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 3/1/24.
//

import SwiftUI
import SwiftData

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
        .modelContainer(for: Manga.self){ result in
            guard case .success(let container) = result else { return }
            let _ = container.mainContext
        }
//        Si lo hacemos de esta otra manera nos permitiría cardar datos, o hacer qualquier cosa, a la bbdd al inicio de la app.
//        Esto recuperaria el context del ilo principal para permitirnos hacer lo que queramos.
//        .modelContainer(for: Manga.self){ result in
//            guard case .success(let container) = result else { return }
//            let _ = container.mainContext
//        }
    }
}
