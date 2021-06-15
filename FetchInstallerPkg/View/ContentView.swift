//
//  ContentView.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-09.
//

import SwiftUI


struct ContentView: View {
    @StateObject var catalog = SUCatalog()
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Download Full Installer")
                .font(.title)
                .multilineTextAlignment(.leading)
            
            List(catalog.installers, id: \.id) { installer in
                InstallerView(product: installer)
            }
            DownloadView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




