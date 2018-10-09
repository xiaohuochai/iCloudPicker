//
//  iCloudManager.swift
//  cloud
//
//  Created by Teng Wang 王腾 on 2018/10/8.
//  Copyright © 2018 Teng Wang 王腾. All rights reserved.
//

import UIKit

public class ICloudManager: NSObject {

    /// 存放的默认路径
    static let iCloudBoxPath = NSHomeDirectory() + "/Documents/iCloudBox/"

    /// 判断iCloud是否可用
    ///
    /// - Returns: ture false
    public class func iCloudEnable() -> Bool {
        let manager = FileManager.default
        if let _ = manager.url(forUbiquityContainerIdentifier: nil) {
            return true
        } else {
            return false
        }
    }
    
    /// 通过iCloudDocument 打开和关闭文件
    ///
    /// - Parameters:
    ///   - documentURL: documentURL description
    ///   - callBack: 文件数据、文件大小 kb
    public class func download(with documentURL: URL, callBack: @escaping (NSData?, Float) -> Void) {
        let iCloudDoc = iCloudDocument.init(fileURL: documentURL)
        iCloudDoc.open { (result) in
            if result {
                let size = ICloudManager.fileSize(atPath: documentURL.path)
                iCloudDoc.close(completionHandler: { (_) in })
                callBack(iCloudDoc.data, size)
            }
        }
    }
    
    /// 保存文件到本地 /Documents/iCloudBox 下
    ///
    /// - Parameters:
    ///   - documentURL: documentURL description
    ///   - maxSize: 保存的最大尺寸
    ///   - callBack: 保存h的路径 url、是否保存成功、保存失败的描述
    public class func save(with documentURL: URL, maxSize: Float, callBack: @escaping (URL?, Bool, String) -> Void) {

        guard ICloudManager.iCloudEnable() else {
            callBack(nil, false, "请在设置->AppleID、iCloud->iCloud中打开访问权限")
            return
        }

        if let fileName = documentURL.lastPathComponent.removingPercentEncoding {
            ICloudManager.download(with: documentURL) { (obj, fileSize) in

                guard fileSize < maxSize else {
                    callBack(nil, false, "文件不能大于\(maxSize)m")
                    return
                }

                if let data = obj {
                    let writeUrl =  URL.init(fileURLWithPath: ICloudManager.iCloudBoxPath + fileName)
                    ICloudManager.createDirectory(atPath: ICloudManager.iCloudBoxPath)
                    do {
                        try data.write(to: writeUrl, options: .atomic)
                        callBack(writeUrl, true, "文件写入成功")
                    } catch {
                        callBack(nil, false, "文件写入失败")
                    }
                }
            }
        } else {
            callBack(nil, false, "文件名不能为空")
        }
    }
}

extension ICloudManager {

    /// 创建文件目录、如果不存在目录会创建目录
    ///
    /// - Parameter atPath: 文件目录
    /// - Returns: 是否创建成功
    @discardableResult
    private class func createDirectory(atPath: String) -> Bool {
        let fileManager = FileManager.default
        let result = fileManager.fileExists(atPath: atPath)
        if result == false {
            do {
                try fileManager.createDirectory(atPath: atPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            } catch {
                return false
            }
            return true
        } else {
            return true
        }
    }

    /// 清除iCloudBox本地缓存, filePath 为空 清除所有缓存
    ///
    /// - Parameter filePath: 为空 清除所有缓存
    public class func cleariCloudBoxCache(filePath: URL = URL(fileURLWithPath: ICloudManager.iCloudBoxPath)) {
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch {

        }
    }

    /// 异步获取iCloudBox 缓存大小
    ///
    /// - Parameter callBack: 大小 kb
    public class func asynciCloudBoxSize(callBack: @escaping(Float) -> Void) {
        DispatchQueue.global().async {
            let size = forderSize(atPath: ICloudManager.iCloudBoxPath)
            callBack(size)
        }
    }

    /// 获取单个文件大小
    ///
    /// - Parameter atPath: 文件路径
    /// - Returns: 文件大小
    private class func fileSize(atPath: String) -> Float {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: atPath) else {
            return 0.0
        }
        do {
            let attr = try fileManager.attributesOfItem(atPath: atPath) as NSDictionary
            return Float(attr.fileSize())
        } catch {
            return 0.0
        }
    }

    /// 获取文件夹的大小
    ///
    /// - Parameter atPath: 文件夹路径
    /// - Returns: 文件夹大小
    private class func forderSize(atPath: String) -> Float {

        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: atPath) else {
            return 0.0
        }
        guard let childFilePaths = fileManager.subpaths(atPath: atPath) else {
            return 0.0
        }

        var fileSize: Float = 0
        for path in childFilePaths {
            let fileAbsoluePath = atPath + "/" + path
            if isDirectory(atPath: fileAbsoluePath) {
                fileSize += 0
            } else {
                fileSize += ICloudManager.fileSize(atPath: fileAbsoluePath)
            }
        }
        return fileSize
    }

    /// 是否是文件夹
    ///
    /// - Parameter atPath: 目录路径
    /// - Returns: true or false
    private class func isDirectory(atPath: String) -> Bool {
        var isDirectory: ObjCBool = ObjCBool(false)
        let fromExist = FileManager.default.fileExists(atPath: atPath,
                                                       isDirectory: &isDirectory)
        return fromExist && isDirectory.boolValue
    }
}

class iCloudDocument: UIDocument {

    var data: NSData?
    
    // 处理文件下载
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        if let userContent = contents as? NSData {
            data = userContent
        }
    }
}
