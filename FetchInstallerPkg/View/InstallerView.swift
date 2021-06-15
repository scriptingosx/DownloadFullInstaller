//
//  InstallerView.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import SwiftUI

struct InstallerView: View {
    @ObservedObject var product: Product
    @StateObject var downloadManager = DownloadManager.shared
    var body: some View {
        if product.isLoading {
            Text("Loading...")
        } else {
            HStack {
                Image(systemName: "shippingbox")
                    .resizable(resizingMode: .stretch)
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color.blue)
                    .frame(width: 40.0, height: 40.0)
                VStack(alignment: .leading) {
                    HStack {
                        Text(product.title ?? "<no title>").font(.headline)
                        Text(product.productVersion ?? "<no version>")
                            .multilineTextAlignment(.leading)
                            .frame(width: 60.0)
                        Text(product.buildVersion ?? "<no build>")
                    }
                    HStack {
                        Text(product.postDate, style: .date)
                            .font(.footnote)
                    }
                }
                Spacer()
                Button(action: {
                    DownloadManager.shared.download(url: product.installAssistantURL)
                }) {
                    Image(systemName: "arrow.down.circle")
                }.disabled(downloadManager.isDownloading)
            }
        }
    }
}
