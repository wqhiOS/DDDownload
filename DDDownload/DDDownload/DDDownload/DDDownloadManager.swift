//
//  DDDownloadManager.swift
//  DDDownload
//
//  Created by wuqh on 2018/12/11.
//  Copyright © 2018 wuqh. All rights reserved.
//

import UIKit

class DDDownloadManager: NSObject {
    
    static let `default` = DDDownloadManager()
    
    var session: URLSession!
    var dataTasks = [String:URLSessionDownloadTask]()
    
    override init() {
        
        super.init()
        
        session = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: "com.AIDownload"), delegate: self, delegateQueue: OperationQueue.main)
        
    }
    
}

extension DDDownloadManager {
    func setup() {
        
    }
}

extension DDDownloadManager {
    func download(withUrl url: String) {
        guard let URL = URL(string: url) else{
            return
        }
        
        if let data = DDDownloadManager.getResumeData(withUrl: url) {
            let dataTask = session.downloadTask(withResumeData: data)
            dataTasks[url] = dataTask
            dataTask.resume()
        }else {
            let dataTask = session.downloadTask(with: URL)
            dataTasks[url] = dataTask
            dataTask.resume()
        }
        
    }
    func cancelDownload(withUrl url: String) {
        dataTasks[url]?.cancel(byProducingResumeData: { (data) in
            if let resumeData = data {
                DDDownloadManager.setResuemData(withUrl: url, data: resumeData)
            }else {
                print("没有数据")
            }
        })
    }
}

extension DDDownloadManager: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let url = downloadTask.currentRequest?.url?.absoluteString {
            try? FileManager.default.moveItem(at: location, to: DDDownloadManager.downloadFilePath(url))
            try? FileManager.default.removeItem(atPath: DDDownloadManager.resumeDataFilePath(url).path)
        }

    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        if let url = downloadTask.currentRequest?.url?.absoluteString {
            
            if self.dataTasks[url] == nil {
                self.dataTasks[url] = downloadTask
                cancelDownload(withUrl: url)
            }
            
            NotificationCenter.default.post(name: NSNotification.Name.init(url.md5), object: nil, userInfo: ["url":url,"progress":Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)])
            
            
        }
        
    }
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
//        print(#function)
//    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
        
    }
}


// MARK: - resumeData操作相关
extension DDDownloadManager {
    static private func getResumeData(withUrl url: String) -> Data? {
        if FileManager.default.fileExists(atPath: resumeDataFilePath(url).path) {
            return try? Data(contentsOf: resumeDataFilePath(url))
        }else {
            return nil
        }
    }
    static private func setResuemData(withUrl url: String,data: Data) {
        try! data.write(to: resumeDataFilePath(url))
    }
}

// MARK: - 文件操作相关
extension DDDownloadManager {
    
    class var downloadDirectory: String {
        
        return String.init(NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!) + "/DDDownload/"
    }
    
    class var resumeDataDirectory: String {
        return String.init(NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!) + "/resumeData/"
    }
    
    static func downloadFilePath(_ fileName: String) -> URL {
        
        if FileManager.default.fileExists(atPath: DDDownloadManager.downloadDirectory) == false {
            try? FileManager.default.createDirectory(atPath: DDDownloadManager.downloadDirectory, withIntermediateDirectories: false, attributes: nil)
        }
        
        return URL(fileURLWithPath: DDDownloadManager.downloadDirectory + "\(fileName.md5)" + ".mp4")
    }
    static private func resumeDataFilePath(_ fileName: String) -> URL {
        if FileManager.default.fileExists(atPath: DDDownloadManager.resumeDataDirectory) == false {
            try? FileManager.default.createDirectory(atPath: DDDownloadManager.resumeDataDirectory, withIntermediateDirectories: false, attributes: nil)
        }
        return URL(fileURLWithPath: DDDownloadManager.resumeDataDirectory + "\(fileName.md5)")
    }
}
