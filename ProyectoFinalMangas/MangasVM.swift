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
    var mangasArray: [Manga] = []
    
    var showAlert = false
    var msg = ""
    
    init(network: DataInteractor = Network.shared) {
        self.network = network
        Task {
            await MainActor.run { loading = true }
            await getMangasItems()
            await MainActor.run { loading = false }
        }
    }
    
    func getMangasItems() async {
        do{
            let mangasPorPagina = 1000
            // Primero recuperamos el primer "paquete" de mangas para poder saber cuantos mangas hay en total
            let mangas = try await network.getMangasItems(itemsPorPagina: mangasPorPagina, pagina: 1)
            // Segundo buscamos cuantos "paquetes" salen de dividir el numero de mangas por los mangas por pagina. Y lo redondeamos al alza para no dejarnos ninguno.
            let paquetes = Int(ceil(Double(mangas.metadata.total/mangasPorPagina)))
            // Lo provamos serializado
//            for pagina in 2...paquetes{
//                let mangaItemRecovered = try await self.network.getMangas(itemsPorPagina: mangasPorPagina, pagina: pagina)
//                self.mangasItemsArray.append(mangaItemRecovered)
//            }
            // Tercero vamos a crear un grupo de tascas en asyncronia para cada llamada getMangas así vamos a recuperar todos los mangas de la forma más eficiente.
            try await withThrowingTaskGroup(of: MangasItems.self){ group in
                // Creamos las tascas en funcion del número de mangas en paquetes de mangasPorPagina
                for pagina in 2...paquetes{
                    group.addTask{
                        try await self.network.getMangasItems(itemsPorPagina: mangasPorPagina, pagina: pagina)
                    }
                }
                for try await mangaItem in group.compactMap({$0}){
                    self.mangasItemsArray.append(mangaItem)
//                    await MainActor.run {
//                        mangasArray = mangasArray + mangaItem.items.map{$0.toPresentacion}
//                        for mangaRecuperado in mangaItem.items {
//                            mangasArray.append(mangaRecuperado.toPresentacion)
//                        }
//                    }
                }
            }
            // Ahora hemos de añadir los mangas de la primera llamada.
            await MainActor.run {
                self.mangasItemsArray.append(mangas)
                //mangasArray = mangasArray + mangas.items.map{$0.toPresentacion}
//                for mangaRecuperado in mangas.items {
//                    mangasArray.append(mangaRecuperado.toPresentacion)
//                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    
}
