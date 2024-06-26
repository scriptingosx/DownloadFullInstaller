//
//  DownloadManager.swift
//  FetchInstallerPkg
//
//  Created by Armin Briegel on 2021-06-14.
//

import Foundation
import AppKit

@objc class DownloadManager: NSObject, ObservableObject {
    @Published var downloadURL: URL?
    @Published var localURL: URL?
    @Published var isDownloading = false
    @Published var progress: Double = 0.0
    @Published var progressString: String = ""
    @Published var isComplete = false
    @Published var filename: String?
    
    lazy var urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
    var downloadTask : URLSessionDownloadTask?
    var byteFormatter = ByteCountFormatter()
    
    static let shared = DownloadManager()
    
    var fileExists: Bool {
        let destination = Prefs.downloadURL
        if self.filename != nil {
            let file = destination.appendingPathComponent(filename!)
            return FileManager.default.fileExists(atPath: file.path)
        } else {
            return false
        }
    }
    
    func download(url: URL?, replacing: Bool = false) throws {
        // reset the variables
        progress = 0.0
        isDownloading = true
        localURL = nil
        downloadURL = url
        isComplete = false
        
        byteFormatter.countStyle = .file
        
        if replacing {
            let destination = Prefs.downloadURL
            let suggestedFilename = filename ?? "InstallerAssistant.pkg"
            let file = destination.appendingPathComponent(suggestedFilename)
            try FileManager.default.removeItem(at: file)
        }
        
        if url != nil {
            downloadTask = urlSession.downloadTask(with: url!)
            downloadTask!.resume()
        }
    }
    
    func cancel() {
        if isDownloading && downloadTask != nil {
            downloadTask?.cancel()
            isDownloading = false
            localURL = nil
            downloadURL = nil
            progress = 0.0
        }
    }
    
    func revealInFinder() {
        if isComplete {
            let destination = Prefs.downloadPath
            NSWorkspace.shared.selectFile(localURL?.path, inFileViewerRootedAtPath: destination)
        }
    }
}

extension DownloadManager : URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        NSLog("urlSession, didFinishDownloading")
        let destination = Prefs.downloadURL
        
        // get the suggest file name or create a uuid string
        let suggestedFilename = filename ?? downloadTask.response?.suggestedFilename ?? UUID().uuidString
        
        do {
            let file = destination.appendingPathComponent(suggestedFilename)
            let newURL = try FileManager.default.replaceItemAt(file, withItemAt: location)
            NSLog("downloaded to \(newURL?.path ?? "### something went wrong ###")")
            DispatchQueue.main.async {
                self.isDownloading = false
                self.localURL = newURL
                self.isComplete = true
            }
        }
        catch {
            NSLog(error.localizedDescription)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        NSLog("urlSession, didWriteData: \(totalBytesWritten)/\(totalBytesExpectedToWrite)")
        DispatchQueue.main.async {
            self.progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            self.progressString = "\(self.byteFormatter.string(fromByteCount: totalBytesWritten))/\(self.byteFormatter.string(fromByteCount: totalBytesExpectedToWrite))"
        }
    }
}

