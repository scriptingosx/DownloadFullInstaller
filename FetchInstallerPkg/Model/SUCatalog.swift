//
//  SUCatalog.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-09.
//

import Foundation

class SUCatalog: ObservableObject {
	
	var thisComponent: String { return String(describing: self)	}

    @Published var catalog: Catalog?
	var products: [String: Product]? { return catalog?.products }
    
	@Published var installers = [Product]()
	var uniqueInstallersList: [String] = []
	
    @Published var isLoading = false
    @Published var hasLoaded = false
    
    init() {
        load()
    }
    
    func load() {
		uniqueInstallersList = []
		let catalogURLArray: [URL] = catalogURL(for: Prefs.seedProgram, for: Prefs.osNameID)
		//print("\(self.thisComponent) : \(String(describing: catalogURL))")
        
		catalogURLArray.forEach {
			let sessionConfig = URLSessionConfiguration.ephemeral
			let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
			
			let task = session.dataTask(with: $0) { data, response, error in
				
				if error != nil {
					print("\(self.thisComponent) : \(error!.localizedDescription)")
					return
				}
				
				let httpResponse = response as! HTTPURLResponse
				if httpResponse.statusCode != 200 {
					print("\(self.thisComponent) : \(httpResponse.statusCode)")
				} else {
					if data != nil {
						//print("\(self.thisComponent) : \(String(decoding: data!, as: UTF8.self))")
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
    }
    
    private func decode(data: Data) {
        self.isLoading = false
        self.hasLoaded = true

        let decoder = PropertyListDecoder()
        self.catalog = try! decoder.decode(Catalog.self, from: data)
        
        if let products = self.products {
			print("\(self.thisComponent) : Installer Nb : loaded \(Prefs.seedProgram) catalog with \(products.count) products")
			
			for (productKey, product) in products {
                product.key = productKey
				if let metainfo = product.extendedMetaInfo {
					if metainfo.sharedSupport != nil {
						if !uniqueInstallersList.contains(productKey) {
							// this is an installer, add to list
							print("\(self.thisComponent) : Installer ID : \(productKey)")
							uniqueInstallersList.append(productKey)
							self.installers.append(product)
							//print("\(self.thisComponent) :     BuildManifest: \(product.buildManifestURL ?? "<no>")")
							//print("\(self.thisComponent) :     InstallAssistant: \(String(describing: product.installAssistantURL))")
							product.loadDistribution()
						}
					}
				}
            }
            //print("\(self.thisComponent) : \(self.installers.count) installer pkgs found")
			installers.sort { $0.postDate > $1.postDate }
		}
    }
}
