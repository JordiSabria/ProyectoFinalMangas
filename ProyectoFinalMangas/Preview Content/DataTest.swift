//
//  DataTest.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 8/1/24.
//

import Foundation

extension DTOMangas{
    static let test = DTOMangas(id: 33, title: "Pita-Ten", titleEnglish: "Pita-Ten", titleJapanese: "ぴたテン", status: "finished", startDate: "1999-08-27T00:00:00Z", endDate: "2003-06-27T00:00:00Z", chapters: 47, volumes: 8, score: 7.37, authors: [], genres: [], themes: [], demographics: [], sypnosis: "On planet Di Gi Charat, little Digiko was a pampered princess. Now living on Earth, the green-haired moppet is working for minimum wage at a hobby shop in Japan. Who ever said it was easy being cute? Based on the popular anime series, Di Gi Charat also features bratty Usada, shy boy Minagawa, and Digiko's wacky companions Puchiko and Gemo! \n\n(Source: VIZ Media)", background: "Di Gi Charat: Koushiki Comic Anthology was published in English as Di Gi Charatf by VIZ Media from December 24, 2003 to April 28, 2004.", mainPicture: "https://cdn.myanimelist.net/images/manga/1/267784l.jpg", url: "https://myanimelist.net/manga/33/Pita-Ten")
}
extension DTOAuthor{
    static let test = DTOAuthor(firstName: "Akira", lastName: "Toriyama", role: "Story & Art", id: UUID(uuidString: "998C1B16-E3DB-47D1-8157-8389B5345D03")!)
}
extension DTODemographic{
    static let test = DTODemographic(id: UUID(), demographic: "Seinen")
}
extension DTOGenre{
    static let test = DTOGenre(id: UUID(), genre: "Fantasy")
}
extension DTOTheme{
    static let test = DTOTheme(id: UUID(), theme: "Detective")
}
extension Manga{
    static let test = Manga(id: 33, title: "Pita-Ten", titleEnglish: "Pita-Ten", titleJapanese: "ぴたテン", status: "finished", startDate: Date(), endDate: Date(),
                            chapters: 47, volumes: 8, score: 7.37, authors: [], genres: [], themes: [], demographics: [], sypnosis: "On", background: "Di.", mainPicture: "https://cdn.myanimelist.net/images/manga/1/267784l.jpg", url: "https://myanimelist.net/manga/33/Pita-Ten", volumesBuyed: 2, volumeReading: 2, completCollection: false)
}

extension MangasVM {
    static let test = MangasVM(network: DataTestNetwork())
    static let testByAuthor = MangasVM(network: DataTestNetwork(), estadoPantalla: .authors)
    static let testByDemographic = MangasVM(network: DataTestNetwork(), estadoPantalla: .demographics)
    static let testByGenre = MangasVM(network: DataTestNetwork(), estadoPantalla: .genres)
    static let testByThemes = MangasVM(network: DataTestNetwork(), estadoPantalla: .themes)
}

struct DataTestNetwork: DataInteractor {
    
    static let shared = Network()
    
    func getJSON<JSON>(request: URLRequest, type: JSON.Type) async throws -> JSON where JSON: Codable {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 80 // Ajusta este valor según sea necesario
        let session = URLSession(configuration: configuration)

        let (data, response) = try await session.getData(for: request)
        //let (data, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode == 200 {
            do {
                return try JSONDecoder().decode(type, from: data)
            } catch {
                throw NetworkError.json(error)
            }
        } else {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    func postJSON(request: URLRequest, status: Int = 200) async throws {
        let (_, response) = try await URLSession.shared.getData(for: request)
        if response.statusCode != status {
            throw NetworkError.status(response.statusCode)
        }
    }
    
    func getMangasItems(itemsPorPagina: Int, pagina: Int) async throws -> MangasItems {
        var mangasObtenidos = try await getJSON(request: .get(url: .getMangasbyPages(itemsPorPagina: 50, pagina: pagina)), type: MangasItems.self)
        mangasObtenidos.metadata.total = 20
        return mangasObtenidos
    }
    func getBestMangasItems() async throws -> MangasItems {
        try await getJSON(request: .get(url: .getBestMangas), type: MangasItems.self)
    }
    func getAuthors() async throws -> [DTOAuthor] {
        try await getJSON(request: .get(url: .getAuthors), type: [DTOAuthor].self)
    }
    func getDemographics() async throws -> [String] {
        try await getJSON(request: .get(url: .getDemographics), type: [String].self)
    }
    func getGenres() async throws -> [String] {
        try await getJSON(request: .get(url: .getGenres), type: [String].self)
    }
    func getThemes() async throws -> [String] {
        try await getJSON(request: .get(url: .getThemes), type: [String].self)
    }
    func getMangasItemsByAuthors(idAuthor: UUID, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems {
        try await getJSON(request: .get(url: .getMangaByAuthor(idAuthor: idAuthor, itemsPorPagina: 50, pagina: pagina)), type: MangasItems.self)
    }
    func getMangasItemsByDemographics(demographic: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems {
        var mangasObtenidos = try await getJSON(request: .get(url: .getMangaByDemographic(demographic: demographic, itemsPorPagina: 50, pagina: pagina)), type: MangasItems.self)
        mangasObtenidos.metadata.total = 20
        return mangasObtenidos
    }
    func getMangasItemsByGenre(genre: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems {
        var mangasObtenidos = try await getJSON(request: .get(url: .getMangaByGenre(genre: genre, itemsPorPagina: 50, pagina: pagina)), type: MangasItems.self)
        mangasObtenidos.metadata.total = 20
        return mangasObtenidos
    }
    func getMangasItemsByTheme(theme: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems {
        var mangasObtenidos = try await getJSON(request: .get(url: .getMangaByTheme(theme: theme, itemsPorPagina: 50, pagina: pagina)), type: MangasItems.self)
        mangasObtenidos.metadata.total = 20
        return mangasObtenidos
    }
}
