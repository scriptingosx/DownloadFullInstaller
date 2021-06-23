//
//  MetaInfo.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

struct MetaInfo: Codable {
    let installAssistantPackageIdentifiers: [String: String]?
    
    var installInfo: String? {
        return installAssistantPackageIdentifiers?["InstallInfo"]
    }
    var osInstall: String? {
        return installAssistantPackageIdentifiers?["OSInstall"]
    }
    var sharedSupport: String? {
        return installAssistantPackageIdentifiers?["SharedSupport"]
    }
    var info: String? {
        return installAssistantPackageIdentifiers?["Info"]
    }
    var updateBrain: String? {
        return installAssistantPackageIdentifiers?["UpdateBrain"]
    }
    var buildManifest: String? {
        return installAssistantPackageIdentifiers?["BuildManifest"]
    }
    
    enum CodingKeys: String, CodingKey {
        case installAssistantPackageIdentifiers = "InstallAssistantPackageIdentifiers"
    }
}
