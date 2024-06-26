//
//  Product.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

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
    
    var darwinVersion: String {
        if buildVersion != nil {
            return String(buildVersion!.prefix(2))
        } else {
            return "unknown"
        }
    }
    
    var buildManifestURL: String? {
        let buildManifest = packages.first { $0.url.hasSuffix("BuildManifest.plist")}
        return buildManifest?.url
    }
    
    var installerPackage: Package? {
        return packages.first { $0.url.hasSuffix("InstallAssistant.pkg")}
    }
    
    var installAssistantURL: URL? {
        if let installAssistant = self.installerPackage {
            return URL(string: installAssistant.url)
        } else {
            return nil
        }
    }
    
    var installAssistantSize: Int {
        return self.installerPackage?.size ?? 0
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
            //print("     Build Version: \(self.buildVersion ?? "<none>")")
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
        //print(self.title ?? "<no title>")
        //print(self.buildVersion ?? "<no buildversion>")
    }
    
    enum CodingKeys: String, CodingKey {
        case serverMetadataURL = "ServerMetadataURL"
        case packages = "Packages"
        case postDate = "PostDate"
        case distributions = "Distributions"
        case extendedMetaInfo = "ExtendedMetaInfo"
    }
}
