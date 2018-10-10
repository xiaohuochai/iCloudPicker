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
    public static let iCloudBoxPath = NSHomeDirectory() + "/Documents/iCloudBox/Doc"
    
    public static let iCloudBoxDownLoadPath = NSHomeDirectory() + "/Documents/iCloudBox/Download/"
    
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
                let size = ICloudFileHelper.fileSize(atPath: documentURL.path)
                iCloudDoc.close(completionHandler: { (_) in })
                callBack(iCloudDoc.data, size)
            }
        }
    }
    
    /// 保存文件到本地 /Documents/iCloudBox 下
    ///
    /// - Parameters:
    ///   - documentURL: documentURL description
    ///   - maxSize: 保存的最大尺寸 为 nil 忽略
    ///   - callBack: 保存h的路径 url、是否保存成功、保存失败的描述
    public class func save(with documentURL: URL, maxSize: Float?, callBack: @escaping (ICloudDocumentModel?, Bool, String) -> Void) {
        
        guard ICloudManager.iCloudEnable() else {
            callBack(nil, false, "请在设置->AppleID、iCloud->iCloud中打开访问权限")
            return
        }
        
        var forderPath = documentURL.absoluteString.components(separatedBy: "com~apple~CloudDocs").last ?? ""
        
        forderPath = forderPath.replacingOccurrences(of: documentURL.lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "", with: "")
        guard let forderName = forderPath.removingPercentEncoding else {
            callBack(nil, false, "forderName 不存在")
            return
        }
        
        ICloudManager.download(with: documentURL) { (obj, fileSize) in
            
            if let maxSize = maxSize {
                guard fileSize < maxSize else {
                    callBack(nil, false, "文件不能大于\(maxSize)m")
                    return
                }
            }
            if let data = obj {
                let writeUrl = URL.init(fileURLWithPath: ICloudManager.iCloudBoxPath + forderName + documentURL.lastPathComponent)
                ICloudFileHelper.createDirectory(atPath: ICloudManager.iCloudBoxPath + forderName)
                do {
                    try data.write(to: writeUrl, options: .atomic)
                    callBack(ICloudDocumentModel.model(path: writeUrl.path), true, "文件写入成功")
                } catch {
                    callBack(nil, false, "文件写入失败")
                }
            }
        }
        
    }
    
    /// 文件是否在 iCloudBox 存在
    ///
    /// - Parameter fileName: 文件名(fileUrl.lastPathComponent) eg. doc.text
    /// - Returns:
    open class func documentIsExists(fileName: String) -> URL? {
        
        let fileManager = FileManager.default
        
        guard let childFilePaths = fileManager.subpaths(atPath: ICloudManager.iCloudBoxDownLoadPath) else {
            return nil
        }
        
        for path in childFilePaths {
            // 读取文件名
            let fileUrl = URL.init(fileURLWithPath: ICloudManager.iCloudBoxDownLoadPath + path)
            if fileName == fileUrl.lastPathComponent {
                return fileUrl
            }
        }
        return nil
    }
}

extension ICloudManager {
    
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
            let size = ICloudFileHelper.forderSize(atPath: ICloudManager.iCloudBoxPath)
            callBack(size)
        }
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
