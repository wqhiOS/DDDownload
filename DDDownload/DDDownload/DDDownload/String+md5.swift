//
//  String+md5.swift
//  DDDownload
//
//  Created by wuqh on 2018/12/12.
//  Copyright © 2018 wuqh. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {
    var md5: String {
        let str = cString(using: String.Encoding.utf8);
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}
