//
//  SeedProgram.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

var thisComponent: String { return String(describing: "Download_Full_Installer.SeedProgram")	}

// Note: this will be different for Monterey
let regularCatalog = "https://swscan.apple.com/content/catalogs/others/index-15-14-13-12-10.16-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog"

let part1Catalog = "https://swscan.apple.com/content/catalogs/others/index-"
let part3Catalog = "-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog"

let allSeedCatalogs: [String:String] = [
	"15" : "15?-15-14-13-12-10.16",
	"14" : "14?-14-13-12-10.16",
	"13" : "13?-13-12-10.16",
	"12" : "12?-12-10.16",
	"11" : "10.16?-10.16"
]

let defaultPart2Catalog = "15-14-13-12-10.16"

let seedCatalogID: [String:String] = [
	"CustomerSeed" : "customerseed",
	"DeveloperSeed" : "seed",
	"PublicSeed" : "beta",
]

enum SeedProgram: String, CaseIterable, Identifiable {
	case noSeed = "Regular"
    case customerSeed = "CustomerSeed"
    case developerSeed = "DeveloperSeed"
    case publicSeed = "PublicSeed"

    var id: String {self.rawValue}
}

enum OsNameID: String, CaseIterable, Identifiable {
	case osAll = "All OS"
	case osSequoia = "Sequoia"
	case osSonoma = "Sonoma"
	case osVentura = "Ventura"
	case osMonterey = "Monterey"
	case osBigSur = "Big Sur"

	var id: String {self.rawValue}
}

func catalogURL(for selectedseed: SeedProgram, for selectedosname: OsNameID) -> [URL] {

	var catalogURL:[URL] = []
	if selectedseed.rawValue != SeedProgram.noSeed.rawValue {
		let shortVersion = nameOS[selectedosname.rawValue] ?? "99"
		// "99" = All OS or unknown OS name for SeedProgram (not Regular)
		for (keyVersion, part2Catalog) in allSeedCatalogs {
			if shortVersion == "99" || (shortVersion != "99" && shortVersion == keyVersion) {
				catalogURL.append(URL(string: (part1Catalog + part2Catalog.replacingOccurrences(of: "?", with: seedCatalogID[selectedseed.rawValue] ?? defaultPart2Catalog) + part3Catalog))!)
			}
			if shortVersion != "99" && shortVersion == keyVersion { break }
		}
	} else {
		catalogURL.append(URL(string: regularCatalog)!)
	}
	print("\(thisComponent) : \(catalogURL)")
	return catalogURL
}
