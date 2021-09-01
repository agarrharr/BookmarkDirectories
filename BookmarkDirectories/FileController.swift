//
//  FileController.swift
//  BookmarkDirectories
//
//  Created by Adam Garrett-Harris on 9/1/21.
//

import Foundation

class FileController: ObservableObject {
    func getContentsOfDirectory(url: URL) -> [(url: URL, isDirectory: Bool)] {
        do {
            let urls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            return urls.map({ url -> (url: URL, isDirectory: Bool) in
                do {
                    let resourceValues = try url.resourceValues(forKeys: [.isDirectoryKey])
                    return (url, resourceValues.isDirectory!)
                } catch {
                    return (url, false)
                }
            })
        } catch {
            print(error)
            return []
        }
    }
}
