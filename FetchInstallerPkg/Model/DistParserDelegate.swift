//
//  DistParserDelegate.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import Foundation

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
