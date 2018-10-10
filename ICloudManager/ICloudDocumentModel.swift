//
//  ICloudDocumentModel.swift
//  cloud
//
//  Created by Teng Wang 王腾 on 2018/10/10.
//  Copyright © 2018 Teng Wang 王腾. All rights reserved.
//

import UIKit

open class ICloudDocumentModel: NSObject {

    open var fileURL: URL?
    
    /// 文件的名称
    /// eg. “/tmp/scratch.tiff” -> “/tmp/scratch”
    /// eg. “/tmp/” -> “/tmp”
    /// eg. “scratch..tiff” -> “scratch.”
    open var fileName: String?
    
    open var fileIsExist = false
   
    /// 文件的相关属性. Use: fileAttributes.fileSize()
    open var fileAttributes: NSDictionary?
    
    /// 创建 ICloudDocumentModel 实例， 会进行参数的初始化操作
    ///
    /// - Parameter path: 文档j路径
    /// - Returns: ICloudDocumentModel 实例
    open class func model(path: String) -> ICloudDocumentModel {
        
        let documentModel = ICloudDocumentModel()
        
        guard !path.isEmpty else {
            return documentModel
        }
        
        documentModel.fileURL = URL.init(fileURLWithPath: path)
        
        // 读取文件名
        if let fileUrl = documentModel.fileURL {
            let pathString = NSString.init(string: fileUrl.lastPathComponent)
            documentModel.fileName = pathString.deletingPathExtension
        }
        
        let fileManager = FileManager.default
        documentModel.fileIsExist = fileManager.fileExists(atPath: path)
        
        // 获取文件相关属性
        guard let fileAttributes = ICloudFileHelper.fileAttr(atPath: path) else {
            return documentModel
        }
        documentModel.fileAttributes = fileAttributes
        
        return documentModel
    }
}
