//
//  SeedProgram.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

// Note: this will be different for Monterey
private let defaultCatalog = "https://swscan.apple.com/content/catalogs/others/index-11-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog"

struct SeedCatalog {
    var customerSeed: String
    var developerSeed: String
    var publicSeed: String
}

extension SeedCatalog: Decodable {

    enum Program: String, CodingKey, CaseIterable {
        case customerSeed = "CustomerSeed"
        case developerSeed = "DeveloperSeed"
        case publicSeed = "PublicSeed"
    }
}

extension SeedCatalog.Program: Identifiable {

    var id: String { rawValue }
}

extension SeedCatalog.Program {

    static let seedPathURL = URL(fileURLWithPath: "/System/Library/PrivateFrameworks/Seeding.framework/Resources/SeedCatalogs.plist")

    var catalogURL: URL {
        guard var catalogURL = URL(string: defaultCatalog) else {
            preconditionFailure("Unable to build a URL from \(defaultCatalog)")
        }

        // read plist file
        let decoder = PropertyListDecoder()

        let seedString: String
        do {
            let data = try Data.init(contentsOf: Self.seedPathURL)
            let seedCatalog = try decoder.decode(SeedCatalog.self, from: data)
            seedString = seedCatalog.stringFor(program: self)
        } catch {
            print("Error while retrieving data at \(Self.seedPathURL.path). \(error.localizedDescription)")
            return catalogURL
        }

        if let seedURL = URL(string: seedString) {
            catalogURL = seedURL
        }

        return catalogURL
    }
}

extension SeedCatalog {

    func stringFor(program: Program) -> String {
        switch program {
        case .customerSeed: return customerSeed
        case .developerSeed: return developerSeed
        case .publicSeed: return publicSeed
        }
    }
}
