//
//  DataManager.swift
//  jiracmd
//
//  Created by marty-suzuki on 2018/06/04.
//

import Foundation

protocol DataTrait {
    associatedtype RawObject: Codable
    static var filename: String { get }
}

enum DataManagerError: Error {
    case invalidURL(String)
    case createFileFailed(URL)
}

final class DataManager<Trait: DataTrait> {
    let fileManager: FileManager
    let workingDirectory: String

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.workingDirectory = "/usr/local/etc/jiracmd"
    }

    private func workingDirectoryURL() throws -> URL {
        let urlString = "file://\(workingDirectory)"
        return try URL(string: urlString) ?? {
            throw DataManagerError.invalidURL(urlString)
        }()
    }

    func getURL() throws -> URL {
        let urlString = "file://\(workingDirectory)/\(Trait.filename).dat"
        return try URL(string: urlString) ?? {
            throw DataManagerError.invalidURL(urlString)
        }()
    }

    func getRawModel() throws -> Trait.RawObject? {
        let url = try getURL()
        if fileManager.fileExists(atPath: url.path) {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Trait.RawObject.self, from: data)
        } else {
            return nil
        }
    }

    func write(_ object: Trait.RawObject) throws {
        let data = try JSONEncoder().encode(object)
        let fileURL = try getURL()

        if fileManager.fileExists(atPath: fileURL.path) {
            try data.write(to: fileURL)
        } else {
            let dirURL = try workingDirectoryURL()
            try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
            if !fileManager.createFile(atPath: fileURL.path, contents: data, attributes: [.posixPermissions: 0o755]) {
                throw DataManagerError.createFileFailed(fileURL)
            }
        }
    }
}
