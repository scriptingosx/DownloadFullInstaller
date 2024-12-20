//
//  DistParserDelegate.swift
//  OSNames
//
//  Created on 09/12/2024.
//

import Foundation

// From Short Darwin (2 first chars) -to-> OS Name
// From OS Name -to-> Short Version (2, 4 or 5 first chars)
var nameOS: [String:String] = [
	"11" : "Lion",
	"12" : "Mountain Lion",
	"13" : "Mavericks",
	"14" : "Yosemite",
	"15" : "El Capitan",
	"16" : "Sierra",
	"17" : "High Sierra",
	"18" : "Mojave",
	"19" : "Catalina",
	"20" : "Big Sur",
	"21" : "Monterey",
	"22" : "Ventura",
	"23" : "Sonoma",
	"24" : "Sequoia",
	"99" : "macOS",
	"Lion" : "10.7",
	"Mountain Lion" : "10.8",
	"Mavericks" : "10.9",
	"Yosemite" : "10.10",
	"El Capitan" : "10.11",
	"Sierra" : "10.12",
	"High Sierra" : "10.13",
	"Mojave" : "10.14",
	"Catalina" : "10.15",
	"Big Sur" : "11",
	"Monterey" : "12",
	"Ventura" : "13",
	"Sonoma" : "14",
	"Sequoia" : "15",
	"macOS" : "99",
	"All OS" : "99"
]
