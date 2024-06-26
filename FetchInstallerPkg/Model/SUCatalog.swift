//
//  SUCatalog.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-09.
//

import Foundation

class SUCatalog: ObservableObject {
    @Published var catalog: Catalog?
    var products: [String: Product]? { return catalog?.products }
    
    @Published var installers = [Product]()
    
    @Published var isLoading = false
    @Published var hasLoaded = false
    
    init() {
        load()
    }
    
    func load() {
        let catalogURL = catalogURL(for: Prefs.seedProgram)
        //print(catalogURL.absoluteString)
        
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
        self.installers = [Product]()
        task.resume()
    }
    
    private func decode(data: Data) {
        self.isLoading = false
        self.hasLoaded = true

        let decoder = PropertyListDecoder()
        self.catalog = try! decoder.decode(Catalog.self, from: data)
        
        if let products = self.products {
            //print("loaded catalog with \(products.count) products")
                        
            for (productKey, product) in products {
                product.key = productKey
                if let metainfo = product.extendedMetaInfo {
                    if metainfo.sharedSupport != nil {
                        // this is an installer, add to list
                        self.installers.append(product)
                        //print("\(productKey) is an installer")
                        //print("    BuildManifest: \(product.buildManifestURL ?? "<no>")")
                        //print("    InstallAssistant: \(String(describing: product.installAssistantURL))")
                        product.loadDistribution()
                    }
                }
            }
            //print("found \(self.installers.count) installer pkgs")
            installers.sort { $0.postDate > $1.postDate }
        }
    }
}





