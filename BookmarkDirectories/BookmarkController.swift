//
//  BookmarkController.swift
//  BookmarkDirectories
//
//  Created by Adam Garrett-Harris on 8/20/21.
//

import SwiftUI

class BookmarkController: ObservableObject {
    @Published var bookmarks: [(uuid: String, url: URL)] = []
    
    init(loadFakeData: Bool = false) {
        if loadFakeData {
            bookmarks = [
                ("123", URL(string: "some/path/Notes")!),
                ("124", URL(string: "some/path/Family%20Notes")!)
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
                bookmarks.append((uuid, url))
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
        self.bookmarks = files?.compactMap { file in
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
                return (file.lastPathComponent, url)
            }
            catch {
                // Handle the error here.
                return nil
            }
        } ?? []
    }
    
    func removeBookmark(at offsets: IndexSet) {
        let uuids = offsets.map( { bookmarks[$0].uuid })
        
        // Remove bookmarks from  urls array
        bookmarks.remove(atOffsets: offsets)
        
        // Delete the bookmark file
        uuids.forEach({ uuid in
            let url = getAppSandboxDirectory().appendingPathComponent(uuid)
            try? FileManager.default.removeItem(at: url)
        })
    }
    
    private func getAppSandboxDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
