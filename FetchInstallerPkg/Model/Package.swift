//
//  Package.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

struct Package: Codable {
    let size: Int
    let url: String
    let digest: String?
    let metadataURL: String?
        
    enum CodingKeys: String, CodingKey {
        case size = "Size"
        case url = "URL"
        case digest = "Digest"
        case metadataURL = "MetadataURL"
    }
}
