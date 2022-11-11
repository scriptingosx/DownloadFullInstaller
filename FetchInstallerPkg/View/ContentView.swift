//
//  ContentView.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-09.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var sucatalog: SUCatalog
    @AppStorage(Prefs.key(.seedProgram)) var seedProgram: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Download Full Installer")
                .font(.title)
                .multilineTextAlignment(.leading)
            
            List(sucatalog.installers, id: \.id) { installer in
                InstallerView(product: installer)
            }.padding(4)
            DownloadView()
        }
        .padding()
        .frame(minWidth: 400.0, maxWidth: 400.0, minHeight: 400.0)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




