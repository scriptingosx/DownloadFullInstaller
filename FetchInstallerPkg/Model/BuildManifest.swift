//
//  BuildManifest.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

struct BuildManifest: Codable {
    let productBuildVersion: String
    let productVersion: String

    enum CodingKeys: String, CodingKey {
        case productBuildVersion = "ProductBuildVersion"
        case productVersion = "ProductVersion"
    }
}
