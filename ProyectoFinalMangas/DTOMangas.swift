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
    let startDate: String?
    let endDate: String?
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
}
//extension MangasItems{
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//    }
//    static func == (lhs: MangasItems, rhs: MangasItems) -> Bool {
//        lhs.id == rhs.id
//    }
//}
struct DTOGenre: Codable, Hashable {
    let id: UUID
    let genre: String
}
struct DTODemographic: Codable, Hashable {
    let id: UUID
    let demographic: String
}
struct DTOTheme: Codable, Hashable {
    let id: UUID
    let theme: String
}
struct DTOAuthor: Codable, Hashable {
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
