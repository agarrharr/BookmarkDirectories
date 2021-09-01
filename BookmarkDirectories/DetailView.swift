//
//  DetailView.swift
//  BookmarkDirectories
//
//  Created by Adam Garrett-Harris on 9/1/21.
//

import SwiftUI

struct DetailView: View {
    var url: URL
    @State var items: [(url: URL, isDirectory: Bool)] = []
    
    @EnvironmentObject var fileController: FileController
    
    var body: some View {
        List {
            ForEach(items, id: \.url) { item in
                HStack {
                    Image(systemName: item.isDirectory ? "folder" : "doc")
                    Text(item.url.lastPathComponent)
                }
            }
        }
        .onAppear {
            items = fileController.getContentsOfDirectory(url: url)
        }
        .navigationTitle(url.lastPathComponent)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(url: URL(string: "path/to/Notes")!)
                .environmentObject(FileController())
        }
    }
}
