//
//  DataModel.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 23/1/24.
//

import Foundation
import SwiftData

@Model
final class Manga {
    //@Attribute(.unique) let id: Int
    let id: Int
    let title: String?
    let titleEnglish: String?
    let titleJapanese: String?
    let status: String?
    let startDate: Date? // Haig de passar-ho a Date
    let endDate: Date? // Haig de passar-ho a Date
    let chapters: Int?
    let volumes: Int? // número de "libros"
    let score: Double
    var authors: [ZAuthor]?
    var genres: [ZGenre]?
    var themes: [ZTheme]?
    var demographics: [ZDemographic]?
    let sypnosis: String?
    let background: String?
    let mainPicture: String?
    let url: String?
    var volumesBuyed: Int
    var volumeReading: Int
    var completCollection: Bool
    
    init(id: Int, title: String?, titleEnglish: String?, titleJapanese: String?, status: String?, startDate: Date?, endDate: Date?, chapters: Int?, volumes: Int?, score: Double, authors: [ZAuthor]?, genres: [ZGenre]?, themes: [ZTheme]?, demographics: [ZDemographic]?, sypnosis: String?, background: String?, mainPicture: String?, url: String?, volumesBuyed: Int, volumeReading: Int, completCollection:Bool) {
        self.id = id
        self.title = title
        self.titleEnglish = titleEnglish
        self.titleJapanese = titleJapanese
        self.status = status
        self.startDate = startDate
        self.endDate = endDate
        self.chapters = chapters
        self.volumes = volumes
        self.score = score
        self.authors = authors
        self.genres = genres
        self.themes = themes
        self.demographics = demographics
        self.sypnosis = sypnosis
        self.background = background
        self.mainPicture = mainPicture
        self.url = url
        self.volumesBuyed = volumesBuyed
        self.volumeReading = volumeReading
        self.completCollection = completCollection
    }
}
//@Model
//final class MangaAuthor {
//    @Relationship(deleteRule: .nullify) var manga: Manga
//    @Relationship(deleteRule: .nullify) var author: Author
//    
//    init(manga: Manga, author: Author) {
//        self.manga = manga
//        self.author = author
//    }
//}
@Model
final class ZAuthor {
    //@Attribute(.unique) let id: UUID
    let id: UUID
    let firstName: String
    let lastName: String
    let role: String
    @Relationship(inverse: \Manga.authors) var mangas: [Manga]?
    //var mangas: [Manga]
    
    init(id: UUID, firstName: String, lastName: String, role: String, mangas: [Manga]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.role = role
        self.mangas = mangas
    }
}
//@Model
//final class MangaGenre {
//    @Relationship(deleteRule: .nullify) var manga: Manga
//    @Relationship(deleteRule: .nullify) var genre: Genre
//    
//    init(manga: Manga, genre: Genre) {
//        self.manga = manga
//        self.genre = genre
//    }
//}
@Model
final class ZGenre {
    //@Attribute(.unique) let id: UUID
    let id: UUID
    let genre: String
    @Relationship(deleteRule: .nullify, inverse: \Manga.genres) var mangas: [Manga]
    //var mangas: [Manga]?
    
    init(id: UUID, genre: String, mangas: [Manga]) {
        self.id = id
        self.genre = genre
        self.mangas = mangas
    }
}
//@Model
//final class MangaTheme {
//    @Relationship(deleteRule: .nullify) var manga: Manga
//    @Relationship(deleteRule: .nullify) var theme: Theme
//    
//    init(manga: Manga, theme: Theme) {
//        self.manga = manga
//        self.theme = theme
//    }
//}
@Model
final class ZTheme {
    //@Attribute(.unique) let id: UUID
    let id: UUID
    let theme: String
    @Relationship(inverse: \Manga.themes) var mangas: [Manga]?
    //var mangas: [Manga]?
    
    init(id: UUID, theme: String, mangas: [Manga]?) {
        self.id = id
        self.theme = theme
        self.mangas = mangas
    }
}
//@Model
//final class MangaDemographic {
//    @Relationship(deleteRule: .nullify) var manga: Manga
//    @Relationship(deleteRule: .nullify) var demographic: Demographic
//    
//    init(manga: Manga, demographic: Demographic) {
//        self.manga = manga
//        self.demographic = demographic
//    }
//}
@Model
final class ZDemographic {
    //@Attribute(.unique) let id: UUID
    let id: UUID
    let demographic: String
    @Relationship(deleteRule: .nullify, inverse: \Manga.demographics) var mangas: [Manga]
    //var mangas: [Manga]?
    
    init(id: UUID, demographic: String, mangas: [Manga]) {
        self.id = id
        self.demographic = demographic
        self.mangas = mangas
    }
}


//@Model
//final class Libro {
//    @Attribute(.unique) let id: Int
//    let name: String
//    @Relationship(inverse: \LibrosAutores.autor) var autores: [LibrosAutores]?
//    
//    init(id: Int, name: String) {
//        self.id = id
//        self.name = name
//    }
//}
//
//@Model
//final class LibrosAutores {
//    @Relationship(deleteRule: .deny) let libro: Libro
//    @Relationship(deleteRule: .deny) let autor: Autor
//    
//    init(libro: Libro, autor: Autor) {
//        self.libro = libro
//        self.autor = autor
//    }
//}
//
//@Model
//final class Autor {
//    @Attribute(.unique) let id: Int
//    let name: String
//    @Relationship(inverse: \LibrosAutores.libro) var libros: [LibrosAutores]?
//    
//    init(id: Int, name: String) {
//        self.id = id
//        self.name = name
//    }
//}

@Model
class Movie {
    @Attribute(.unique) let id: Int
    var name: String
    var releaseYear: Int
    @Relationship(inverse: \Actor.movies) var cast: [Actor]?
    //var cast: [Actor]
    
    init(id: Int, name: String, releaseYear: Int, cast: [Actor]) {
        self.id = id
        self.name = name
        self.releaseYear = releaseYear
        self.cast = cast
    }
}

@Model
class Actor {
    @Attribute(.unique) let id: Int
    var name: String
    var movies: [Movie]?
    //@Relationship(inverse: \Movie.cast) var movies: [Movie]
    init(id: Int, name: String, movies: [Movie]) {
        self.id = id
        self.name = name
        self.movies = movies
    }
}


