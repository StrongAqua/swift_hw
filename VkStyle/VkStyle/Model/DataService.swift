//
//  PhotoCache.swift
//  VkStyle
//
//  Created by aprirez on 11/16/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import PromiseKit

class DataService {
    
    private var dataCollection = [String: Data]()

    private static let cacheLifeTime: TimeInterval = 24 * 60 * 60
    private static let pathName: String = {
        
        let pathName = "data"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        clearDataCache(path: url.path)
                        
        return pathName
    }()
    
    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last
        guard let urlEncodedHashName = hashName?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {return "default"}

        return cachesDirectory.appendingPathComponent(DataService.pathName + "/" + urlEncodedHashName).path
    }
    
    static private func clearDataCache(path: String) {
        let fileManager = FileManager.default
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: path)
            for filePath in filePaths {
                let fullFilePath = path + "/" + filePath
                var removeFile = false
                if let info = try? FileManager.default.attributesOfItem(atPath: fullFilePath),
                   let modificationDate = info[FileAttributeKey.modificationDate] as? Date
                {
                    let lifeTime = Date().timeIntervalSince(modificationDate)
                    removeFile = lifeTime > cacheLifeTime
                } else {
                    removeFile = true
                }
                if removeFile {
                    try fileManager.removeItem(atPath: fullFilePath)
                }
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    private func saveDataToCache(url: String, data: Data) {
        guard let fileName = getFilePath(url: url) else {return}
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
    private func getDataFromCache(url: String) -> Data? {
        guard
            let fileName = getFilePath(url: url),
            let info = try? FileManager.default.attributesOfItem(atPath: fileName),
            let modificationDate = info[FileAttributeKey.modificationDate] as? Date
            else { return nil }
        
        let lifeTime = Date().timeIntervalSince(modificationDate)
        
        guard
            lifeTime <= DataService.cacheLifeTime,
            let data = try? Data(contentsOf: URL(fileURLWithPath: fileName)) else { return nil }

        DispatchQueue.main.async {
            self.dataCollection[url] = data
        }
        return data
    }
    
    private func download(urlString: String, completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url, completionHandler: {
            data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(data)
            }
        }).resume()
    }

    func get(byUrl url: String, completion: @escaping (Data?) -> ()) {
        if let data = dataCollection[url] {
            completion(data)
        } else if let data = getDataFromCache(url: url) {
            completion(data)
        } else {
            download(urlString: url, completion: {
                [weak self] data in
                guard let data = data else {return}
                self?.saveDataToCache(url: url, data: data)
                DispatchQueue.main.async {
                    self?.dataCollection[url] = data
                }
                completion(data)
            })
        }
    }
    
    enum DownloadErrors : Error {
        case wrongURL
    }

    func getPromise(_ urlString: String) -> Promise<Data> {
        let promiseData = Promise<Data> { resolver in
            guard let url = URL(string: urlString) else {
                resolver.reject(DownloadErrors.wrongURL)
                return
            }
            URLSession.shared.dataTask(with: url) {
                data, _, error in
                if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill(data ?? Data())
                }
            }
            .resume()
        }
        return promiseData
    }
}
