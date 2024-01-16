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
    let metadata: DTOMedatada

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
    var toPresentacion: Manga{
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
              authors: authors,
              genres: genres,
              themes: themes,
              demographics: demographics,
              sypnosis: sypnosis,
              background: background,
              mainPicture: mainPicture?.replacingOccurrences(of: "\"", with: ""),
              url: url?.replacingOccurrences(of: "\"", with: ""))
    }
}
struct DTOGenre: Codable, Hashable, Identifiable{
    let id: UUID
    let genre: String
}
struct DTODemographic: Codable, Hashable, Identifiable {
    let id: UUID
    let demographic: String
}
struct DTOTheme: Codable, Hashable, Identifiable {
    let id: UUID
    let theme: String
}
struct DTOAuthor: Codable, Hashable, Identifiable {
    let firstName: String
    let lastName: String
    let role: String
    let id: UUID
}
struct DTOMedatada: Codable, Hashable {
    let total: Int
    let page: Int
    let per: Int  // items por página
}
