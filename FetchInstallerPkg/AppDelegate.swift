//
//  AppDelegate.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation
import AppKit

enum DefaultsKeys: String {
    case seedProgram = "SeedProgram"
	case osNameID = "OsNameID"
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Prefs.registerDefaults()
    }
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		return true
	}
}
