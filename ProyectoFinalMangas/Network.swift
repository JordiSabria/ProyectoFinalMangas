//
//  Network.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 4/1/24.
//

import Foundation

protocol DataInteractor {
    func getMangasItems(itemsPorPagina: Int, pagina: Int ) async throws -> MangasItems
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
}
