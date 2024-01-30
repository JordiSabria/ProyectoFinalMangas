//
//  Network.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 4/1/24.
//

import Foundation

protocol DataInteractor {
    func getMangasItems(itemsPorPagina: Int, pagina: Int ) async throws -> MangasItems
    func getBestMangasItems() async throws -> MangasItems
    func getAuthors() async throws -> [DTOAuthor]
    func getDemographics() async throws -> [String]
    func getGenres() async throws -> [String]
    func getThemes() async throws -> [String]
    func getMangasItemsByAuthors(idAuthor: UUID, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems
    func getMangasItemsByDemographics(demographic: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems
    func getMangasItemsByGenre(genre: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems
    func getMangasItemsByTheme(theme: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems
    func getMangasAdvSearch(advSearch: CustomSearch) async throws -> MangasItems
    
}

struct Network: DataInteractor {
    
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
        try await getJSON(request: .get(url: .getMangasbyPages(itemsPorPagina: itemsPorPagina, pagina: pagina)), type: MangasItems.self)
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
        try await getJSON(request: .get(url: .getMangaByAuthor(idAuthor: idAuthor, itemsPorPagina: itemsPorPagina, pagina: pagina)), type: MangasItems.self)
    }
    func getMangasItemsByDemographics(demographic: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems {
        try await getJSON(request: .get(url: .getMangaByDemographic(demographic: demographic, itemsPorPagina: itemsPorPagina, pagina: pagina)), type: MangasItems.self)
    }
    func getMangasItemsByGenre(genre: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems {
        try await getJSON(request: .get(url: .getMangaByGenre(genre: genre, itemsPorPagina: itemsPorPagina, pagina: pagina)), type: MangasItems.self)
    }
    func getMangasItemsByTheme(theme: String, itemsPorPagina: Int, pagina: Int) async throws -> MangasItems {
        try await getJSON(request: .get(url: .getMangaByTheme(theme: theme, itemsPorPagina: itemsPorPagina, pagina: pagina)), type: MangasItems.self)
    }
    func getMangasAdvSearch(advSearch: CustomSearch) async throws -> MangasItems {
        try await getJSON(request: .post(url: .getManga, data: advSearch), type: MangasItems.self)
    }
}
