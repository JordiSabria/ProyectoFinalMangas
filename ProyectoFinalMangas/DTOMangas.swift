//
//  DTOMangas.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 3/1/24.
//

import Foundation

struct MangasItems : Codable, Hashable, Identifiable{
    let id: UUID
    let items: [DTOMangas]
    var metadata: DTOMedatada

    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            // Decodificar las otras propiedades
            items = try container.decode([DTOMangas].self, forKey: .items)
            metadata = try container.decode(DTOMedatada.self, forKey: .metadata)
            id = UUID() // Generar un UUID nuevo
        }

        enum CodingKeys: String, CodingKey {
            case items, metadata // No incluir 'id' aquí
        }
}
struct DTOMangas: Codable, Hashable, Identifiable{
    let id: Int
    let title: String?
    let titleEnglish: String?
    let titleJapanese: String?
    let status: String?
    let startDate: String? // Haig de passar-ho a Date
    let endDate: String? // Haig de passar-ho a Date
    let chapters: Int?
    let volumes: Int?
    let score: Double
    let authors: [DTOAuthor]
    let genres: [DTOGenre]
    let themes: [DTOTheme]
    let demographics: [DTODemographic]
    let sypnosis: String?
    let background: String?
    let mainPicture: String? // igual que url
    let url: String? // ojo ex: "\"https://myanimelist.net/manga/33/Pita-Ten\"" - Abra que convertirlo a URL
    
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
extension DTOMangas{
    var toData: Manga{
        Manga(id: id,
              title: title,
              titleEnglish: titleEnglish,
              titleJapanese: titleJapanese,
              status: status,
              startDate: getDateFromString(dateString: startDate),
              endDate: getDateFromString(dateString: endDate),
              chapters: chapters,
              volumes: volumes,
              score: score,
              authors: authors.map{$0.toData},
              genres: genres.map{$0.toData},
              themes: themes.map{$0.toData},
              demographics: demographics.map{$0.toData},
              sypnosis: sypnosis,
              background: background,
              mainPicture: mainPicture?.replacingOccurrences(of: "\"", with: ""),
              url: url?.replacingOccurrences(of: "\"", with: ""),
              volumesBuyed: 0,
              volumeReading: 0,
              completCollection: false)
    }
}
struct DTOGenre: Codable, Hashable, Identifiable{
    let id: UUID
    let genre: String
}
extension DTOGenre{
    var toData: ZGenre{
        ZGenre(id: id, genre: genre, mangas: [])
    }
}
struct DTODemographic: Codable, Hashable, Identifiable {
    let id: UUID
    let demographic: String
}
extension DTODemographic{
    var toData: ZDemographic{
        ZDemographic(id: id, demographic: demographic, mangas: [])
    }
}
struct DTOTheme: Codable, Hashable, Identifiable {
    let id: UUID
    let theme: String
}
extension DTOTheme{
    var toData: ZTheme{
        ZTheme(id: id, theme: theme, mangas: [])
    }
}
struct DTOAuthor: Codable, Hashable, Identifiable {
    let firstName: String
    let lastName: String
    let role: String
    let id: UUID
}
extension DTOAuthor{
    var toData: ZAuthor{
        ZAuthor(id: id, firstName: firstName, lastName: lastName, role: role, mangas: [])
    }
}
struct DTOMedatada: Codable, Hashable {
    var total: Int
    let page: Int
    let per: Int  // items por página
}
struct CustomSearch: Codable {
    var searchTitle: String?
    var searchAuthorFirstName: String?
    var searchAuthorLastName: String?
    var searchGenres: [String]?
    var searchThemes: [String]?
    var searchDemographics: [String]?
    var searchContains: Bool
}
