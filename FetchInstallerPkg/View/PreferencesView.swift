//
//  PreferencesView.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import SwiftUI

struct PreferencesView: View {
    @AppStorage(Prefs.key(.seedProgram)) var seedProgram: String = ""
    @AppStorage(Prefs.key(.downloadPath)) var downloadPath: String = ""
    @EnvironmentObject var sucatalog: SUCatalog
    
    let labelWidth = 100.0
    var body: some View {
        Form {
            VStack {
                HStack {
                    Picker("Seed Program:", selection: $seedProgram) {
                        ForEach(SeedProgram.allCases) { program in
                            Text(program.rawValue)
                        }
                    }
                    .onChange(of: seedProgram) { _ in
                        sucatalog.load()
                    }

                }
                HStack {
                    Text("Download to:")
                    TextField("Download path", text: $downloadPath).environment(\.isEnabled, false)
                }
            }
            .padding()
        }
        .frame(width: 300.0, height: 300.0)
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
