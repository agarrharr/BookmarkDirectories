//
//  BookmarkDirectoriesApp.swift
//  BookmarkDirectories
//
//  Created by Adam Garrett-Harris on 8/20/21.
//

import SwiftUI

@main
struct BookmarkDirectoriesApp: App {
    @StateObject var bookmarkController = BookmarkController()
    @StateObject var fileController = FileController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookmarkController)
                .environmentObject(fileController)
        }
    }
}
