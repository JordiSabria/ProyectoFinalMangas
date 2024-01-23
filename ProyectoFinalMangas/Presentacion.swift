//
//  Presentacion.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 8/1/24.
//

import Foundation

//struct Manga: Codable, Hashable, Identifiable{
//    let id: Int
//    let title: String?
//    let titleEnglish: String?
//    let titleJapanese: String?
//    let status: String?
//    let startDate: Date?
//    let endDate: Date?
//    let chapters: Int?
//    let volumes: Int?
//    let score: Double
//    let authors: [DTOAuthor]
//    let genres: [DTOGenre]
//    let themes: [DTOTheme]
//    let demographics: [DTODemographic]
//    let sypnosis: String?
//    let background: String?
//    let mainPicture: String?
//    let url: String?
//}

enum search {
    case allMangas
    case bestMangas
    case authors
    case demographics
    case genres
    case themes
    case superSearch
}

enum estadoPantalla {
    case search
    case authors
    case demographics
    case genres
    case themes
    case mangas
    case detailManga
}
