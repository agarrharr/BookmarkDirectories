//
//  ContentView.swift
//  BookmarkDirectories
//
//  Created by Adam Garrett-Harris on 8/20/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bookmarkController: BookmarkController
    @State var showFilePicker = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(bookmarkController.urls, id: \.self) { url in
                        Text(url.lastPathComponent)
                    }
                }
                
                Button {
                    showFilePicker = true
                } label: {
                    Label("Add Folder", systemImage: "plus")
                }
                .sheet(isPresented: $showFilePicker, content: {
                    DocumentPicker()
                })
            }
            .navigationTitle("Folders")
            .listStyle(InsetGroupedListStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BookmarkController(loadFakeData: true))
        ContentView()
            .environmentObject(BookmarkController())
    }
}
