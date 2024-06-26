//
//  Catalog.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

struct Catalog: Codable {
    let catalogVersion: Int
    let applePostURL: String
    let indexDate: Date
    let products: [String: Product]
    
    enum CodingKeys: String, CodingKey {
        case catalogVersion = "CatalogVersion"
        case applePostURL = "ApplePostURL"
        case indexDate = "IndexDate"
        case products = "Products"
    }
}
