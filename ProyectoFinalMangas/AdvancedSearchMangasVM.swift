//
//  AdvancedSearchMangasVM.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 22/1/24.
//

import SwiftUI

@Observable
final class AdvancedSearchMangasVM {
    let network: DataInteractor
    
    var searchTitle: String = ""
    var searchAuthorFirstName: String = ""
    var searchAuthorLastName: String = ""
    var searchGenres: [String] = []
    var searchSetGenres: Set<UUID> = []
    var searchThemes: [String] = []
    var searchSetThemes: Set<UUID> = []
    var searchDemographics: [String] = []
    var searchSetDemographics: Set<UUID> = []
    var searchContains: Bool = false
    
    var mangasItemsArray: [MangasItems] = []
    
    init(network: DataInteractor = Network.shared) {
        self.network = network
    }
    
    func cleanAdvSearchMangas(){
        searchTitle = ""
        searchAuthorFirstName = ""
        searchAuthorLastName = ""
        searchGenres = []
        searchSetGenres = []
        searchThemes = []
        searchSetThemes = []
        searchDemographics = []
        searchSetDemographics = []
        searchContains = false
    }
    func getAdvSearchMangas(mangasVM: MangasVM) async{
        do{
            mangasItemsArray = []
            // 1- Enpaquetar todos los datos en un objeto de tipo CustomSearch
            for searchGenreUUID in searchSetGenres {
                for genre in mangasVM.genres where genre.id == searchGenreUUID{
                    searchGenres.append(genre.genre)
                }
            }
            for searchThemeUUID in searchSetThemes {
                for theme in mangasVM.themes where theme.id == searchThemeUUID{
                    searchThemes.append(theme.theme)
                }
            }
            for searchDemographicUUID in searchSetDemographics {
                for demographic in mangasVM.demographics where demographic.id == searchDemographicUUID{
                    searchDemographics.append(demographic.demographic)
                }
            }
            searchContains = true
            var newCustomSearch = CustomSearch(searchContains: searchContains)
            if !searchTitle.isEmpty { newCustomSearch.searchTitle = searchTitle }
            if !searchAuthorFirstName.isEmpty { newCustomSearch.searchAuthorFirstName = searchAuthorFirstName }
            if !searchAuthorLastName.isEmpty { newCustomSearch.searchAuthorLastName = searchAuthorLastName }
            if !searchGenres.isEmpty { newCustomSearch.searchGenres = searchGenres }
            if !searchThemes.isEmpty { newCustomSearch.searchThemes = searchThemes }
            if !searchDemographics.isEmpty { newCustomSearch.searchDemographics = searchDemographics }
            
            // 2- Hacemos la llamada APIREST para pedir los mangas.
            let mangasPorPagina = 10
            // Primero recuperamos el primer "paquete" de mangas para poder saber cuantos mangas hay en total
            let mangasSearchAdv = try await network.getMangasAdvSearch(advSearch: newCustomSearch)
            // Segundo buscamos cuantos "paquetes" salen de dividir el numero de mangas por los mangas por pagina. Y lo redondeamos al alza para no dejarnos ninguno.
            let paquetes = Int(ceil(Double(mangasSearchAdv.metadata.total/mangasPorPagina)))
            // Ahora hemos de añadir los mangas de la primera llamada.
            await MainActor.run {
                self.mangasItemsArray.append(mangasSearchAdv)
            }
            // Tercero, si hay más de un paquete: vamos a crear un grupo de tascas en asyncronia para cada llamada getMangas así vamos a recuperar todos los mangas de la forma más eficiente.
            if paquetes > 1 {
                try await withThrowingTaskGroup(of: MangasItems.self){ group in
                    // Creamos las tascas en funcion del número de mangas en paquetes de mangasPorPagina
                    for pagina in 2...paquetes{
                        group.addTask{
                            try await self.network.getMangasItems(itemsPorPagina: mangasPorPagina, pagina: pagina)
                        }
                    }
                    for try await mangaItem in group.compactMap({$0}){
                        self.mangasItemsArray.append(mangaItem)
                    }
                }
            }
        } catch {
            await MainActor.run {
                mangasVM.msg = "\(error)"
                mangasVM.showAlert.toggle()
            }
        }
        
    }
    
    
    
}
