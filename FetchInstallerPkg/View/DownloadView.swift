//
//  DownloadView.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-15.
//

import SwiftUI

struct DownloadView: View {
    @StateObject var downloadManager = DownloadManager.shared
    
    var body: some View {
        if downloadManager.isDownloading {
            VStack(alignment: .leading) {
                HStack {
                    Text("Downloading \(downloadManager.filename ?? "InstallAssistant.pkg")")
                    Spacer()
                    Text(downloadManager.progressString)
                        .font(.footnote)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
                HStack {
                    ProgressView(value: downloadManager.progress)
                    Button(action: {downloadManager.cancel()}) {
                        Image(systemName: "xmark.circle.fill").accentColor(.gray)
                    }.buttonStyle(.borderless)
                }
                
            }
            .multilineTextAlignment(.leading)
        }
        if downloadManager.isComplete {
            HStack {
                Text("Downloaded \(downloadManager.filename ?? "InstallAssistant.pkg")")
                Spacer()
                Button(action: {
                    downloadManager.revealInFinder()
                }) {
                    Image(systemName: "magnifyingglass")
                    Text("Show in Finder")
                }
            }
        }
    }
}

struct DownloadView_Previews : PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}

