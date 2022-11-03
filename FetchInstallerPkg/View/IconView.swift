//
//  IconView.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-16.
//

import SwiftUI

struct IconView: View {
    @ObservedObject var product: Product
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            if product.darwinVersion == "20" {
                Image("Big Sur")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.blue)
            }
            else if product.darwinVersion == "21" {
                Image("Monterey")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.blue)
            }
            else if product.darwinVersion == "22" {
                Image("Ventura")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.blue)
            }
            else {
                Image("macOS")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.blue)
            }
            if product.title != nil && product.title!.lowercased().contains("beta") {
                Text("beta")
                    .font(.footnote)
                    .foregroundColor(.white)
                    .background(Color.gray.opacity(0.8))
                
            }
        }.frame(width: 48.0, height: 48.0)
    }
}

//struct IconView_Previews: PreviewProvider {
//    static var previews: some View {
//        //IconView(product: nil)
//    }
//}
