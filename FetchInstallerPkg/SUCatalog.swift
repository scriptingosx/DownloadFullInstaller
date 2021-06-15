//
//  SUCatalog.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-09.
//

import Foundation

class SUCatalog: ObservableObject {
    static let catalogAddress = "https://swscan.apple.com/content/catalogs/others/index-11-10.15-10.14-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog"
    
    @Published var catalog: Catalog?
    var products: [String: Product]? { return catalog?.products }
    
    @Published var installers = [Product]()
    
    @Published var isLoading = false
    @Published var hasLoaded = false
    
    init() {
        load()
    }
    
    private func load() {
        guard let catalogURL = URL(string: SUCatalog.catalogAddress) else {return}
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        
        let task = session.dataTask(with: catalogURL) { data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode != 200 {
                print(httpResponse.statusCode)
            } else {
                if data != nil {
                    //print(String(decoding: data!, as: UTF8.self))
                    DispatchQueue.main.async {
                        self.decode(data: data!)                    }
                 }
            }
        }
        isLoading = true
        hasLoaded = false
        self.catalog = nil
        task.resume()
    }
    
    private func decode(data: Data) {
        self.isLoading = false
        self.hasLoaded = true

        let decoder = PropertyListDecoder()
        self.catalog = try! decoder.decode(Catalog.self, from: data)
        
        if let products = self.products {
            print("loaded catalog with \(products.count) products")
                        
            for (productKey, product) in products {
                product.key = productKey
                if let metainfo = product.extendedMetaInfo {
                    if metainfo.sharedSupport != nil {
                        // this is an installer, add to list
                        self.installers.append(product)
                        print("\(productKey) is an installer")
                        print("    BuildManifest: \(product.buildManifestURL ?? "<no>")")
                        print("    InstallAssistant: \(String(describing: product.installAssistantURL))")
                        product.loadDistribution()
                    }
                }
            }
            print("found \(self.installers.count) installer pkgs")
        }
        
    }
}

// MARK: - Structs

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

class Product: Codable, Identifiable, ObservableObject {
    let serverMetadataURL: String?
    let packages: [Package]
    let postDate: Date
    let distributions: [String: String]
    let extendedMetaInfo: MetaInfo?
    
    @Published var key: String?
    
    @Published var title: String?
    @Published var buildVersion: String?
    var id : String {
        return key ?? "<no id yet>"
    }
    
    @Published var productVersion: String?
    @Published var installerVersion: String?
    
    @Published var isLoading = false
    @Published var hasLoaded = false
    
    var distributionURL: String? {
        if distributions.keys.contains("English") {
            return distributions["English"]!
        } else if distributions.keys.contains("en"){
            return distributions["en"]!
        }
        return nil
    }
    
    var buildManifestURL: String? {
        let buildManifest = packages.first { $0.url.hasSuffix("BuildManifest.plist")}
        return buildManifest?.url
    }
    
    var installAssistantURL: URL? {
        if let installAssistant = packages.first(where: { $0.url.hasSuffix("InstallAssistant.pkg")}) {
            return URL(string: installAssistant.url)
        } else {
            return nil
        }
        
    }
    
    func loadBuildManifest() {
        guard let urlString = self.buildManifestURL else {return}
        guard let url = URL(string: urlString) else {return}
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode != 200 {
                print(httpResponse.statusCode)
            } else {
                if data != nil {
                    //print(String(decoding: data!, as: UTF8.self))
                    DispatchQueue.main.async {
                        self.decodeBuildManifest(data: data!)                    }
                 }
            }
        }
        
        isLoading = true
        hasLoaded = false
        title = nil
        buildVersion = nil
        productVersion = nil
        installerVersion = nil
        task.resume()
    }
    
    func decodeBuildManifest(data: Data) {
        self.isLoading = false
        self.hasLoaded = true

        let decoder = PropertyListDecoder()
        if let buildManifest = try? decoder.decode(BuildManifest.self, from: data) {
            self.buildVersion = buildManifest.productBuildVersion
            self.productVersion = buildManifest.productVersion
            print("     Build Version: \(self.buildVersion ?? "<none>")")
        }
    }
    
    func loadDistribution() {
        guard let urlString = self.distributionURL else {return}
        guard let url = URL(string: urlString) else {return}
        
        let sessionConfig = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        
        let task = session.dataTask(with: url) { data, response, error in
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode != 200 {
                print(httpResponse.statusCode)
            } else {
                if data != nil {
                    //print(String(decoding: data!, as: UTF8.self))
                    DispatchQueue.main.async {
                        self.parseDistXML(data: data!)                    }
                 }
            }
        }
        
        isLoading = true
        hasLoaded = false
        
        title = nil
        buildVersion = nil
        productVersion = nil
        installerVersion = nil
        task.resume()
    }
    
    func parseDistXML(data: Data) {
        let parser = XMLParser(data: data)
        let delegate = DistParserDelegate()
        parser.delegate = delegate
        parser.parse()
        
        self.title = delegate.title
        self.productVersion = delegate.productVersion
        self.buildVersion = delegate.buildVersion
        self.installerVersion = delegate.installerVersion
        self.isLoading = false
        self.hasLoaded = true
        print(self.title ?? "<no title>")
        print(self.buildVersion ?? "<no buildversion>")
    }
    
    enum CodingKeys: String, CodingKey {
        case serverMetadataURL = "ServerMetadataURL"
        case packages = "Packages"
        case postDate = "PostDate"
        case distributions = "Distributions"
        case extendedMetaInfo = "ExtendedMetaInfo"
    }
}

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
    var updateBran: String? {
        return installAssistantPackageIdentifiers?["UpdateBrain"]
    }
    var buildManifest: String? {
        return installAssistantPackageIdentifiers?["BuildManifest"]
    }
    
    enum CodingKeys: String, CodingKey {
        case installAssistantPackageIdentifiers = "InstallAssistantPackageIdentifiers"
    }
}

struct BuildManifest: Codable {
    let productBuildVersion: String
    let productVersion: String

    enum CodingKeys: String, CodingKey {
        case productBuildVersion = "ProductBuildVersion"
        case productVersion = "ProductVersion"
    }
}

@objc class DistParserDelegate : NSObject, XMLParserDelegate {
    enum Elements: String {
        case pkgref = "pkg-ref"
        case auxinfo
        case key
        case string
        case title
    }
    
    var title = String()
    var buildVersion = String()
    var productVersion = String()
    var installerVersion = String()
    
    private var elementName = String()
    private var parsingAuxinfo = false
    private var currentKey = String()
    private var currentString = String()
    private var keysParsed = 0
        
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        if elementName == Elements.pkgref.rawValue {
            if attributeDict["id"] == "InstallAssistant" {
                if let version = attributeDict["version"] {
                    self.installerVersion = version
                }
            }
        }
                
        if elementName == Elements.auxinfo.rawValue {
            parsingAuxinfo = true
        }
        
        if elementName == Elements.key.rawValue {
            currentKey = String()
        }
        
        if elementName == Elements.string.rawValue {
            currentString = String()
        }
        
        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == Elements.auxinfo.rawValue {
            parsingAuxinfo = false
        }
        
        if elementName == Elements.key.rawValue {
            keysParsed += 1
        }
        
        if elementName == Elements.string.rawValue {
            if currentKey == "BUILD" {
                buildVersion = currentString
            } else if currentKey == "VERSION" {
                productVersion = currentString
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == Elements.title.rawValue {
                title += data
            } else if self.elementName == "key" && parsingAuxinfo {
                currentKey += data
            } else if self.elementName == "string" && parsingAuxinfo {
                currentString += data
            }
        }
    }
}
