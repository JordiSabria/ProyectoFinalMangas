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
    //var mangasArray: [Manga] = []
    var bestMangasItemsArray: [MangasItems] = []
    var authors: [DTOAuthor] = []
    var demographics: [DTODemographic] = []
    var genres: [DTOGenre] = []
    var themes: [DTOTheme] = []
//    var mangasItemsByAuthor: [MangasItems] = []
//    var mangasItemsByDemographic: [MangasItems] = []
//    var mangasItemsByGenre: [MangasItems] = []
//    var mangasItemsByTheme: [MangasItems] = []
    var mangasByAuthorSpecific: [UUID:[MangasItems]] = [:]
    var mangasByDemographicSpecific: [String:[MangasItems]] = [:]
    var mangasByGenresSpecific: [String:[MangasItems]] = [:]
    var mangasByThemesSpecific: [String:[MangasItems]] = [:]
    
    var estadoPantalla: estadoPantalla = .search
    
    var searchAllMangas = ""
    var searchAuthors = ""
    
    var showAlert = false
    var msg = ""
    
    init(network: DataInteractor = Network.shared) {
        self.network = network
//        Task {
//            await MainActor.run { loading = true }
//            await getMangasItems()
//            await MainActor.run { loading = false }
//        }
    }
    init(network: DataInteractor = Network.shared, estadoPantalla: estadoPantalla) {
        self.network = network
        self.estadoPantalla = estadoPantalla
    }
    
    func getMangasItems() async {
        do{
            mangasItemsArray = []
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
            // Ahora hemos de añadir los mangas de la primera llamada.
            await MainActor.run {
                self.mangasItemsArray.append(mangas)
                //mangasArray = mangasArray + mangas.items.map{$0.toPresentacion}
//                for mangaRecuperado in mangas.items {
//                    mangasArray.append(mangaRecuperado.toPresentacion)
//                }
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
    //                    await MainActor.run {
    //                        mangasArray = mangasArray + mangaItem.items.map{$0.toPresentacion}
    //                        for mangaRecuperado in mangaItem.items {
    //                            mangasArray.append(mangaRecuperado.toPresentacion)
    //                        }
    //                    }
                    }
                }
            } 
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getMangasItemsSearchAllMangash() -> [DTOMangas]{
        let arrayTempMangas = mangasItemsArray.map{ $0.items.map{$0} }.flatMap{$0}
        if searchAllMangas.isEmpty{
            return arrayTempMangas
                .sorted{
                    if let titulo1 = $0.title, let titulo2 = $1.title {
                        titulo1 < titulo2
                    }else { true }
                }
        } else {
            return arrayTempMangas
                .filter{
                    $0.title?.range(of: searchAllMangas, options:[.caseInsensitive,.diacriticInsensitive]) != nil
                }
                .sorted{
                    if let titulo1 = $0.title, let titulo2 = $1.title {
                        titulo1 < titulo2
                    }else { true }
                }
        }
    }
    func getBestMangasItems() async {
        do {
            let bestMangasItems = try await self.network.getBestMangasItems()
            await MainActor.run {
                self.bestMangasItemsArray.append(bestMangasItems)
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
        
    }
    func getAuthors() async {
        do{
            authors = []
            let authorsTemp = try await self.network.getAuthors()
            await MainActor.run{
                self.authors.append(contentsOf: authorsTemp)
                authors = authors.sorted {
                    if $0.firstName != $1.firstName {
                        return $0.firstName < $1.firstName
                    } else {
                        return $0.lastName < $1.lastName
                    }
                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getAuthorsSearch() -> [DTOAuthor]{
        return  authors
            .filter{
                if searchAuthors.isEmpty{
                    true
                }else {
                    ($0.firstName+$0.lastName).range(of: searchAuthors, options:[.caseInsensitive,.diacriticInsensitive]) != nil
                }
            }
    }
    func getDemographics() async {
        do{
            demographics = []
            let demographicsTemp = try await self.network.getDemographics()
            await MainActor.run{
                let dtoDemographicArray = demographicsTemp.map { DTODemographic(id: UUID(), demographic: $0) }
                self.demographics.append(contentsOf: dtoDemographicArray)
                demographics = demographics.sorted{
                    return $0.demographic < $1.demographic
                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getGenres() async {
        do{
            genres = []
            let genresTemp = try await self.network.getGenres()
            await MainActor.run{
                let dtoGenresArray = genresTemp.map { DTOGenre(id: UUID(), genre: $0) }
                self.genres.append(contentsOf: dtoGenresArray)
                genres = genres.sorted{
                    return $0.genre < $1.genre
                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getThemes() async {
        do{
            themes = []
            let themesTemp = try await self.network.getThemes()
            await MainActor.run{
                let dtoThemesArray = themesTemp.map { DTOTheme(id: UUID(), theme: $0) }
                self.themes.append(contentsOf: dtoThemesArray)
                themes = themes.sorted{
                    return $0.theme < $1.theme
                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getMangasByAuthor(idAuthor: UUID) async {
        do{
            // Antes que nada vaciamos el array de mangasItemsByAuthor y los mangas del autor
            //mangasItemsByAuthor = []
            // Añadimos el autor dentro del diccionario por si no está.
            mangasByAuthorSpecific[idAuthor] = []
            let mangasPorPagina = 500
            // Primero recuperamos el primer "paquete" de mangas por autor para poder saber cuantos mangas hay en total
            let mangas = try await network.getMangasItemsByAuthors(idAuthor: idAuthor, itemsPorPagina: mangasPorPagina , pagina: 1)
            // Ahora hemos de añadir los mangas de la primera llamada.
            await MainActor.run {
                //self.mangasItemsByAuthor.append(mangas)
                self.mangasByAuthorSpecific[idAuthor]?.append(mangas)
            }
            // Segundo buscamos cuantos "paquetes" salen de dividir el numero de mangas por los mangas por pagina. Y lo redondeamos al alza para no dejarnos ninguno.
            let paquetes = Int(ceil(Double(mangas.metadata.total/mangasPorPagina)))
            // Tercero vamos a crear un grupo de tascas en asyncronia para cada llamada getMangas así vamos a recuperar todos los mangas de la forma más eficiente.
            try await withThrowingTaskGroup(of: MangasItems.self){ group in
                // Creamos las tascas en funcion del número de mangas en paquetes de mangasPorPagina
                if paquetes > 1 {
                    for pagina in 2...paquetes{
                        group.addTask{
                            try await self.network.getMangasItemsByAuthors(idAuthor: idAuthor, itemsPorPagina: mangasPorPagina, pagina: pagina)
                        }
                    }
                    for try await mangaItem in group.compactMap({$0}){
                        //self.mangasItemsByAuthor.append(mangaItem)
                        self.mangasByAuthorSpecific[idAuthor]?.append(mangaItem)
                    }
                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getMangasByDemographic(demographic: String) async {
        do{
            // Antes que nada vaciamos el array de mangasItemsByAuthor
            //mangasItemsByDemographic = []
            // Añadimos el demographic dentro del diccionario por si no está.
            mangasByDemographicSpecific[demographic] = []
            let mangasPorPagina = 500
            // Primero recuperamos el primer "paquete" de mangas por autor para poder saber cuantos mangas hay en total
            let mangas = try await network.getMangasItemsByDemographics(demographic: demographic, itemsPorPagina: mangasPorPagina , pagina: 1)
            // Ahora hemos de añadir los mangas de la primera llamada.
            await MainActor.run {
                //self.mangasItemsByDemographic.append(mangas)
                self.mangasByDemographicSpecific[demographic]?.append(mangas)
            }
            // Segundo buscamos cuantos "paquetes" salen de dividir el numero de mangas por los mangas por pagina. Y lo redondeamos al alza para no dejarnos ninguno.
            let paquetes = Int(ceil(Double(mangas.metadata.total/mangasPorPagina)))
            // Tercero vamos a crear un grupo de tascas en asyncronia para cada llamada getMangas así vamos a recuperar todos los mangas de la forma más eficiente.
            try await withThrowingTaskGroup(of: MangasItems.self){ group in
                // Creamos las tascas en funcion del número de mangas en paquetes de mangasPorPagina
                if paquetes > 1 {
                    for pagina in 2...paquetes{
                        group.addTask{
                            try await self.network.getMangasItemsByDemographics(demographic: demographic, itemsPorPagina: mangasPorPagina , pagina: pagina)
                        }
                    }
                    for try await mangaItem in group.compactMap({$0}){
                        //self.mangasItemsByDemographic.append(mangaItem)
                        self.mangasByDemographicSpecific[demographic]?.append(mangaItem)
                    }
                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getMangasByGenre(genre: String) async {
        do{
            // Antes que nada vaciamos el array de mangasItemsByAuthor
            //mangasItemsByGenre = []
            // Añadimos el genre dentro del diccionario por si no está.
            mangasByGenresSpecific[genre] = []
            let mangasPorPagina = 500
            // Primero recuperamos el primer "paquete" de mangas por autor para poder saber cuantos mangas hay en total
            let mangas = try await network.getMangasItemsByGenre(genre: genre, itemsPorPagina: mangasPorPagina , pagina: 1)
            // Ahora hemos de añadir los mangas de la primera llamada.
            await MainActor.run {
                //self.mangasItemsByGenre.append(mangas)
                self.mangasByGenresSpecific[genre]?.append(mangas)
            }
            // Segundo buscamos cuantos "paquetes" salen de dividir el numero de mangas por los mangas por pagina. Y lo redondeamos al alza para no dejarnos ninguno.
            let paquetes = Int(ceil(Double(mangas.metadata.total/mangasPorPagina)))
            // Tercero vamos a crear un grupo de tascas en asyncronia para cada llamada getMangas así vamos a recuperar todos los mangas de la forma más eficiente.
            try await withThrowingTaskGroup(of: MangasItems.self){ group in
                // Creamos las tascas en funcion del número de mangas en paquetes de mangasPorPagina
                if paquetes > 1 {
                    for pagina in 2...paquetes{
                        group.addTask{
                            try await self.network.getMangasItemsByGenre(genre: genre, itemsPorPagina: mangasPorPagina , pagina: pagina)
                        }
                    }
                    for try await mangaItem in group.compactMap({$0}){
                        //self.mangasItemsByGenre.append(mangaItem)
                        self.mangasByGenresSpecific[genre]?.append(mangaItem)
                    }
                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getMangasByTheme(theme: String) async {
        do{
            // Antes que nada vaciamos el array de mangasItemsByAuthor
            //mangasItemsByTheme = []
            // Añadimos el theme dentro del diccionario por si no está.
            mangasByThemesSpecific[theme] = []
            let mangasPorPagina = 500
            // Primero recuperamos el primer "paquete" de mangas por autor para poder saber cuantos mangas hay en total
            let mangas = try await network.getMangasItemsByTheme(theme: theme, itemsPorPagina: mangasPorPagina , pagina: 1)
            // Ahora hemos de añadir los mangas de la primera llamada.
            await MainActor.run {
                //self.mangasItemsByTheme.append(mangas)
                self.mangasByThemesSpecific[theme]?.append(mangas)
            }
            // Segundo buscamos cuantos "paquetes" salen de dividir el numero de mangas por los mangas por pagina. Y lo redondeamos al alza para no dejarnos ninguno.
            let paquetes = Int(ceil(Double(mangas.metadata.total/mangasPorPagina)))
            // Tercero vamos a crear un grupo de tascas en asyncronia para cada llamada getMangas así vamos a recuperar todos los mangas de la forma más eficiente.
            try await withThrowingTaskGroup(of: MangasItems.self){ group in
                // Creamos las tascas en funcion del número de mangas en paquetes de mangasPorPagina
                if paquetes > 1 {
                    for pagina in 2...paquetes{
                        group.addTask{
                            try await self.network.getMangasItemsByTheme(theme: theme, itemsPorPagina: mangasPorPagina , pagina: pagina)
                        }
                    }
                    for try await mangaItem in group.compactMap({$0}){
                        //self.mangasItemsByTheme.append(mangaItem)
                        self.mangasByThemesSpecific[theme]?.append(mangaItem)
                    }
                }
            }
        } catch {
            await MainActor.run {
                self.msg = "\(error)"
                self.showAlert.toggle()
            }
        }
    }
    func getDateFromString (dateString: String?) -> Date? {

        let dateFormatter = ISO8601DateFormatter()

        if let dateToConvert = dateString{
            if let dateTransformed = dateFormatter.date(from: dateToConvert) {
                return dateTransformed
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
}
