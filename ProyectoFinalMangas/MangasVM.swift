//
//  MangasVM.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 4/1/24.
//

import SwiftUI

@Observable
final class MangasVM {
    let network: DataInteractor
    
    var loading = true
    
    var mangasItemsArray: [MangasItems] = []
    
    var showAlert = false
    var msg = ""
    
    init(network: DataInteractor = Network.shared) {
        self.network = network
//        Task {
//            await MainActor.run { loading = true }
//            //await getEmpleados()
//            await MainActor.run { loading = false }
//        }
    }
    
    func getMangasItems() async {
        do{
            let mangas = try await network.getMangas(itemsPorPagina: 10, pagina: 1)
            /*
             ESTIC AQUÍ
             
             un cop tenim els mangas hem de mirar cuants n'hi ha, dividir per el número de items per pàgina i fer un bucle per recurperar tots els mangas.
             */
            await MainActor.run {
                self.mangasItemsArray.append(mangas)
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    
}
