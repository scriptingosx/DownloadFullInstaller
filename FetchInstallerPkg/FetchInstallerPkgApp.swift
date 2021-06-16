//
//  FetchInstallerPkgApp.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-09.
//

import SwiftUI

@main
struct FetchInstallerPkgApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var sucatalog = SUCatalog()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(sucatalog)
        }
        Settings {
            PreferencesView().environmentObject(sucatalog)
        }
    }
}
