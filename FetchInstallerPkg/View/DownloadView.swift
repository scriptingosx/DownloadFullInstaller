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
                Text("Downloading:")
                Text("\(downloadManager.downloadURL?.absoluteString ?? "<no name>")")
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Text(downloadManager.progressString)
                    .font(.footnote)
                    .lineLimit(1)
                    .truncationMode(.middle)
                HStack {
                    ProgressView(value: downloadManager.progress)
                    Button(action: {downloadManager.cancel()}) {
                        Image(systemName: "xmark.circle.fill").accentColor(.gray)
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

