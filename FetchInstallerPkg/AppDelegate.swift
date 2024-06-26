//
//  AppDelegate.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import AppKit
import Foundation

enum DefaultsKeys: String {
    case seedProgram = "SeedProgram"
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        Prefs.registerDefaults()
    }
}
