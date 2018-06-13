//
//  DataManager.swift
//  cujira
//
//  Created by marty-suzuki on 2018/06/04.
//

import Foundation

/// Trait for DataManager
public protocol DataTrait {
    associatedtype RawObject: Codable
    static var filename: String { get }
}

public enum DataManagerError: Error {
    case invalidURL(String)
    case createFileFailed(URL)
}

enum DataManagerConst {
    static let workingDir = "/usr/local/etc/cujira"
}

/// Manage Data that used in services
///
/// - note: Behaviors of DataManager change with Trait.
public final class DataManager<Trait: DataTrait> {
    private let fileManager: FileManager
    private let workingDirectory: () throws -> String

    public init(workingDirectory: @escaping () throws -> String,
                fileManager: FileManager = .default) {
        self.fileManager = fileManager
        self.workingDirectory = workingDirectory
    }

    private func baseURLString(extraPath: String) throws -> String {
        return try "file://\(workingDirectory())\(extraPath)"
    }

    private func workingDirectoryURL(extraPath: String) throws -> URL {
        let urlString = try baseURLString(extraPath: extraPath)
        return try URL(string: urlString) ?? {
            throw DataManagerError.invalidURL(urlString)
        }()
    }

    private func getURL(extraPath: String) throws -> URL {
        let urlString = try "\(baseURLString(extraPath: extraPath))/\(Trait.filename).dat"
        return try URL(string: urlString) ?? {
            throw DataManagerError.invalidURL(urlString)
        }()
    }

    func getRawModel(extraPath: String = "") throws -> Trait.RawObject? {
        let url = try getURL(extraPath: extraPath)
        if fileManager.fileExists(atPath: url.path) {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(Trait.RawObject.self, from: data)
        } else {
            return nil
        }
    }

    func write(_ object: Trait.RawObject, extraPath: String = "") throws {
        let data = try JSONEncoder().encode(object)
        let fileURL = try getURL(extraPath: extraPath)

        if fileManager.fileExists(atPath: fileURL.path) {
            try data.write(to: fileURL)
        } else {
            let dirURL = try workingDirectoryURL(extraPath: extraPath)
            try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
            if !fileManager.createFile(atPath: fileURL.path, contents: data, attributes: [.posixPermissions: 0o755]) {
                throw DataManagerError.createFileFailed(fileURL)
            }
        }
    }
}

extension DataManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL(let url):
            return "\(url) is invalid URL."
        case .createFileFailed(let url):
            return "Faild to create file to \(url)."
        }
    }
}
