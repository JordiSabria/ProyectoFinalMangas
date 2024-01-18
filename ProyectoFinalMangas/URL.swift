//
//  URL.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 3/1/24.
//

import Foundation

var api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

extension URL {
    // Listados en endpoint (/list)
    static let getMangas = api.appending(path: "/list/mangas")
    static func getMangasbyPages(itemsPorPagina: Int, pagina: Int) -> URL{
        api.appending(path: "/list/mangas").appending(queryItems: [URLQueryItem(name: "per", value: String(itemsPorPagina)), URLQueryItem(name: "page", value: String(pagina))])
    }
    static let getBestMangas = api.appending(path: "/list/bestMangas")
    static let getAuthors = api.appending(path: "/list/authors")
    static let getDemographics = api.appending(path: "/list/demographics")
    static let getGenres = api.appending(path: "/list/genres")
    static let getThemes = api.appending(path: "/list/themes")
    static func getMangaByGenre(genre: String, itemsPorPagina: Int, pagina: Int) -> URL{
        api.appending(path: "/list/mangaByGenre/\(genre)").appending(queryItems: [URLQueryItem(name: "per", value: String(itemsPorPagina)), URLQueryItem(name: "page", value: String(pagina))])
    }
    static func getMangaByDemographic(demographic: String, itemsPorPagina: Int, pagina: Int) -> URL{
        api.appending(path: "/list/mangaByDemographic/\(demographic)").appending(queryItems: [URLQueryItem(name: "per", value: String(itemsPorPagina)), URLQueryItem(name: "page", value: String(pagina))])
    }
    static func getMangaByTheme(theme: String, itemsPorPagina: Int, pagina: Int) -> URL{
        api.appending(path: "/list/mangaByTheme/\(theme)").appending(queryItems: [URLQueryItem(name: "per", value: String(itemsPorPagina)), URLQueryItem(name: "page", value: String(pagina))])
    }
    static func getMangaByAuthor(idAuthor: UUID, itemsPorPagina: Int, pagina: Int) -> URL{
        api.appending(path: "/list/mangaByAuthor/\(idAuthor)").appending(queryItems: [URLQueryItem(name: "per", value: String(itemsPorPagina)), URLQueryItem(name: "page", value: String(pagina))])
    }
    
    // Búsquedas en endpoint (/search)
    static let getMangasBeginsWith = api.appending(path: "/search/mangasBeginsWith")
    static let getMangasContains = api.appending(path: "/search/mangasContains")
    static let getAuthor = api.appending(path: "/search/author")
    static let getManga = api.appending(path: "/search/manga")
    /*
     /manga - Devuelve el manga que corresponde con un ID exacto
            /manga/42
     
     /manga - Método POST que recibe el siguiente JSON:
     struct CustomSearch: Codable {
     var searchTitle: String?
     var searchAuthorFirstName: String?
     var searchAuthorLastName: String?
     var searchGenres: [String]?
     var searchThemes: [String]?
     var searchDemographics: [String]?
     var searchContains: Bool
     }
     Se le puede pasar título, primer nombre de autor, último nombre de
     autor, colección de géneros (como cadenas), de temáticas y de
     demográficos. El valor Bool establece cuando es false la búsqueda de
     valores que empiezan por título y autor, y con true que incluyan la
     cadena.
     Es una búsqueda multipropósito por todos los datos posibles y que
     devuelve por paginación los resultados.
     */
    
}


