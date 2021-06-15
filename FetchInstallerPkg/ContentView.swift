//
//  ContentView.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-09.
//

import SwiftUI


struct ContentView: View {
    @StateObject var catalog = SUCatalog()
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Download Full Installer")
                .font(.title)
                .multilineTextAlignment(.leading)
            
            List(catalog.installers, id: \.id) { installer in
                InstallerView(product: installer)
            }
            DownloadView()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

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

struct DownloadView: View {
    @StateObject var downloadManager = DownloadManager.shared
    
    var body: some View {
        if downloadManager.isDownloading {
            VStack(alignment: .leading) {
                Text("Downloading:")
                Text("\(downloadManager.downloadURL?.absoluteString ?? "<no name>")")
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text(downloadManager.progressString)
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.middle)
                ProgressView(value: downloadManager.progress)
                HStack {
                    Spacer()
                    Button(action: {downloadManager.cancel()}) {
                        Text("Cancel")
                    }
                }
            }
            .multilineTextAlignment(.leading)
        }
        if downloadManager.isComplete {
            Button(action: {
                downloadManager.revealInFinder()
            }) {
                Text("Reveal in Finder")
            }
        }
    }
}
