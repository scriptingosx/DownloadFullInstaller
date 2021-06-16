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
                IconView(product: product)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text(product.title ?? "<no title>")
                            .font(.headline)
                        Spacer()
                        Text(product.productVersion ?? "<no version>")
                            .frame(alignment: .trailing)
                    }
                    HStack {
                        Text(product.postDate, style: .date)
                            .font(.footnote)
                        Spacer()
                        Text(product.buildVersion ?? "<no build>")
                            .frame(alignment: .trailing)
                            .font(.footnote)
                    }
                }
                
                
                Button(action: {
                    DownloadManager.shared.filename = "InstallAssistant-\(product.productVersion ?? "V")-\(product.buildVersion ?? "B").pkg"
                    DownloadManager.shared.download(url: product.installAssistantURL)
                }) {
                    Image(systemName: "arrow.down.circle").font(.title)
                }
                .disabled(downloadManager.isDownloading)
                .buttonStyle(.borderless)
                .controlSize(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
            }.contextMenu() {
                Button(action: {
                    if let text = product.installAssistantURL?.absoluteString {
                        let pb = NSPasteboard.general
                        pb.clearContents()
                        pb.setString(text, forType: .string)
                    }
                }) {
                    Image(systemName: "doc.on.clipboard")
                    Text("Copy Download URL")
                }
            }
        }
    }
}


//struct InstallerView_Previews: PreviewProvider {
//    static var previews: some View {
//        let catalog = SUCatalog()
//                
//        if let preview_product = catalog.installers.first {
//            InstallerView(product: preview_product)
//        } else {
//            Text("could not load catalog")
//        }
//    }
//}
