//
//  BookmarkController.swift
//  BookmarkDirectories
//
//  Created by Adam Garrett-Harris on 8/20/21.
//

import SwiftUI

class BookmarkController: ObservableObject {
    @Published var urls: [URL] = []
    
    init(loadFakeData: Bool = false) {
        if loadFakeData {
            urls = [
                URL(string: "some/path/Notes")!,
                URL(string: "some/path/Family%20Notes")!
            ]
        } else {
            loadAllBookmarks()
        }
    }
    
    func addBookmark(for url: URL) {
        do {
            // Start accessing a security-scoped resource.
            guard url.startAccessingSecurityScopedResource() else {
                // Handle the failure here.
                return
            }
            
            // Make sure you release the security-scoped resource when you finish.
            defer { url.stopAccessingSecurityScopedResource() }
            
            // Convert URL to bookmark
            let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil)
            
            // Save the bookmark into a file (the name of the file is a UUID)
            let uuid = UUID().uuidString
            try bookmarkData.write(to: getAppSandboxDirectory().appendingPathComponent(uuid))
            
            // Add the URL to the urls array
            withAnimation {
                urls.append(url)
            }
        }
        catch {
            // Handle the error here.
            print("Error creating the bookmark")
        }
    }
    
    func loadAllBookmarks() {
        // Get all the bookmark files
        let files = try? FileManager.default.contentsOfDirectory(at: getAppSandboxDirectory(), includingPropertiesForKeys: nil)
        // Map over the bookmark files
        self.urls = files?.compactMap { file in
            do {
                let bookmarkData = try Data(contentsOf: file)
                var isStale = false
                // Get the URL from each bookmark
                let url = try URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &isStale)
                
                guard !isStale else {
                    // Handle stale data here.
                    return nil
                }
                
                // Return URL
                return url
            }
            catch {
                // Handle the error here.
                return nil
            }
        } ?? []
    }
    
    private func getAppSandboxDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
