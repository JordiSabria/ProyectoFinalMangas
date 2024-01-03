//
//  DTOMangas.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 3/1/24.
//

import Foundation

struct MangasItems : Codable {
    let items: [DTOMangas]
    let metadata: DTOMedatada
}
struct DTOMangas: Codable{
    let id: Int
    let title: String
    let titleEnglish: String
    let titleJapanese: String
    let status: String
    let startDate: String
    let endDate: String
    let chapters: Int
    let volumes: Int
    let score: Double
    let authors: [DTOAuthor]
    let genres: [DTOGenre]
    let themes: [DTOTheme]
    let demographics: [DTODemographic]
    let sypnosis: String
    let background: String
    let mainPicture: String // igual que url
    let url: String // ojo ex: "\"https://myanimelist.net/manga/33/Pita-Ten\"" - Abra que convertirlo a URL
}
struct DTOGenre: Codable {
    let id: UUID
    let genre: String
}
struct DTODemographic: Codable {
    let id: UUID
    let demographic: String
}
struct DTOTheme: Codable {
    let id: UUID
    let theme: String
}
struct DTOAuthor: Codable {
    let firstName: String
    let lastName: String
    let role: String
    let id: UUID
}
struct DTOMedatada: Codable {
    let total: Int
    let page: Int
    let per: Int  // items por página
}
