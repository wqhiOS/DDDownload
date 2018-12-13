//
//  DDDownloadModel.swift
//  DDDownload
//
//  Created by wuqh on 2018/12/12.
//  Copyright © 2018 wuqh. All rights reserved.
//

import UIKit

enum DDDownloadState {
    case none//未开始下载
    case pause//暂停
    case playing//下载中
    case wait//等待
    case success//成功
    case faild//失败
}

class DDDownloadModel: NSObject {
    /// 下载地址
    var downloadUrl: String?
    
    /// 下载成功后的文件地址
    var filePath: String?
    
    /// 下载进度
    var progress: Float?
    
    /// 文件总大小
    var totalBytes: Int64?
    
    /// 已下载文件大小
    var totalBytesWritten: Int64?
    
    /// 下载状态
    var state: DDDownloadState = .none
}
