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
