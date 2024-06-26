//
//  SeedProgram.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

// Note: this will be different for Sonoma+
let defaultCatalog = "https://swscan.apple.com/content/catalogs/others/index-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog"

enum SeedProgram: String, CaseIterable, Identifiable {
    case customerSeed = "CustomerSeed"
    case developerSeed = "DeveloperSeed"
    case publicSeed = "PublicSeed"
    case noSeed = "None"
    
    var id: String {self.rawValue}
}
    
func catalogURL(for seed: SeedProgram) -> URL {
    let seedPath = "/System/Library/PrivateFrameworks/Seeding.framework/Resources/SeedCatalogs.plist"
    
    var catalogURL = URL(string: defaultCatalog)!
    
    let seedPathURL = URL(fileURLWithPath: seedPath)
    // read plist file
    let decoder = PropertyListDecoder()
    guard let data = try? Data.init(contentsOf: seedPathURL) else { return catalogURL }
    guard let seedURLDict = try? decoder.decode([String:String].self, from: data) else { return catalogURL }
    if let seedString = seedURLDict[seed.rawValue] {
        if let seedURL = URL(string: seedString) {
            catalogURL = seedURL
        }
    }
    return catalogURL
}
