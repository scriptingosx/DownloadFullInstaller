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
    @State var isReplacingFile = false
    @State var failed = false
    @State var filename = "InstallerAssistant.pkg"
    
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
                        Text(Prefs.byteFormatter.string(fromByteCount: Int64(product.installAssistantSize)))
                            .font(.footnote)
                        Spacer()
                        Text(product.buildVersion ?? "<no build>")
                            .frame(alignment: .trailing)
                            .font(.footnote)
                    }
                }
                
                
                Button(action: {
                    filename = "InstallAssistant-\(product.productVersion ?? "V")-\(product.buildVersion ?? "B").pkg"
                    downloadManager.filename = filename
                    isReplacingFile = downloadManager.fileExists
                    
                    if !isReplacingFile {
                        do {
                            try downloadManager.download(url: product.installAssistantURL)
                        } catch {
                            failed = true
                        }
                    }
                    
                }) {
                    Image(systemName: "arrow.down.circle").font(.title)
                }
                .alert(isPresented: $isReplacingFile) {
                    Alert(
                        title: Text("“\(filename)” already exists! Do you want to replace it?"),
                        message: Text("A file with the same name already exists in that location. Replacing it will overwrite its current contents."),
                        primaryButton: .cancel(Text("Cancel")),
                        secondaryButton: .destructive(
                            Text("Replace"),
                            action: {
                        do {
                            try downloadManager.download(url:  product.installAssistantURL, replacing: true)
                        } catch {
                            failed = true
                        }
                    }
                        )
                    )
                }
//                .alert(isPresented: $failed) {
//                    Alert(
//                        title: Text("An error occured while downloading"),
//                        message: Text("Please try again or restart the application.")
//                    )
//                }
                .disabled(downloadManager.isDownloading)
                .buttonStyle(.borderless)
                .controlSize(/*@START_MENU_TOKEN@*/.large/*@END_MENU_TOKEN@*/)
                .accessibilityLabel("Download Installer \(product.productVersion ?? "unknown")")
                
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
