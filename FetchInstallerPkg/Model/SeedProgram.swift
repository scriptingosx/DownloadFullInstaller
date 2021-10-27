//
//  SeedProgram.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

enum SeedProgram: String, CaseIterable, Identifiable {
    case customerSeed = "CustomerSeed"
    case developerSeed = "DeveloperSeed"
    case publicSeed = "PublicSeed"
    case noSeed = "None"
    
    var id: String {self.rawValue}
}

// return the default catalog URL for the current version of macOS
func defaultCatalog() -> URL? {
    let majorVersion = ProcessInfo.processInfo.operatingSystemVersion.majorVersion
    
    var catalog = ""
    switch majorVersion {
    case 11:
        catalog = "https://swscan.apple.com/content/catalogs/others/index-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog"
    default:
        catalog = "https://swscan.apple.com/content/catalogs/others/index-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog"
    }
    
    return URL(string: catalog)
}

func catalogURL(for seed: SeedProgram) -> URL {
    let seedPath = "/System/Library/PrivateFrameworks/Seeding.framework/Resources/SeedCatalogs.plist"
    
    var catalogURL = defaultCatalog()!
    
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
