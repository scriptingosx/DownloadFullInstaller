//
//  IconView.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-16.
//

import SwiftUI

struct IconView: View {
	
    @ObservedObject var product: Product

	let iconOS: [String:String] = [
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
		"99" : "macOS"
]

  var body: some View {
//		ZStack(alignment: .bottomTrailing) {
		ZStack(alignment: .center) {

			let iconName = iconOS[product.darwinVersion] ?? "macOS"
			Image(iconName)
				.resizable(resizingMode: .stretch)
				.aspectRatio(contentMode: .fit)
				.foregroundColor(Color.blue)

			let isBeta = "beta"
			if product.title != nil && product.title!.lowercased().contains(isBeta) {
				Text(" " + isBeta + " ")
					.font(.headline)
					.foregroundColor(.white)
					.background(Color.blue.opacity(0.8))
					.rotationEffect(.degrees(-45))
			}
        }.frame(width: 50.0, height: 50.0, alignment: .center)
    }
}

/*
struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView(product: nil)
    }
}
*/
