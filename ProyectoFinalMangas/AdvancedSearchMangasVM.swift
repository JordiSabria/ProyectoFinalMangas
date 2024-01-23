//
//  AdvancedSearchMangasVM.swift
//  ProyectoFinalMangas
//
//  Created by Jordi Sabrià Pagès on 22/1/24.
//

import SwiftUI

@Observable
final class AdvancedSearchMangasVM {
    let network: DataInteractor
    
    var searchTitle: String = ""
    var searchAuthorFirstName: String = ""
    var searchAuthorLastName: String = ""
    var serrchGenres: String = ""
    var searchSetGenres: Set<String> = []
    var searchThemes: [String] = []
    var searchSetThemes: Set<String> = []
    var searchDemographics: [String] = []
    var searchSetDemographics: Set<String> = []
    var searchContains: Bool = false
    
    init(network: DataInteractor = Network.shared) {
        self.network = network
    }
    
    
    
}
