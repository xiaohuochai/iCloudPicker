//
//  ICloudFileHelper.swift
//  cloud
//
//  Created by Teng Wang 王腾 on 2018/10/10.
//  Copyright © 2018 Teng Wang 王腾. All rights reserved.
//

import UIKit

public class ICloudFileHelper: NSObject {

    /// 创建文件目录、如果不存在目录会创建目录
    ///
    /// - Parameter atPath: 文件目录
    /// - Returns: 是否创建成功
    @discardableResult
    public class func createDirectory(atPath: String) -> Bool {
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
    
    /// 获取单个文件大小
    ///
    /// - Parameter atPath: 文件路径
    /// - Returns: 文件大小
    public class func fileSize(atPath: String) -> Float {
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
    
    /// 获取文件属性
    ///
    /// - Parameter atPath: 文件路径
    /// - Returns: 文件大小
    public class func fileAttr(atPath: String) -> NSDictionary? {
        let fileManager = FileManager.default
        guard fileManager.fileExists(atPath: atPath) else {
            return nil
        }
        do {
            let attr = try fileManager.attributesOfItem(atPath: atPath) as NSDictionary
            return attr
        } catch {
            return nil
        }
    }
    
    
    /// 获取文件夹的大小
    ///
    /// - Parameter atPath: 文件夹路径
    /// - Returns: 文件夹大小
    public class func forderSize(atPath: String) -> Float {
        
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
                fileSize += ICloudFileHelper.fileSize(atPath: fileAbsoluePath)
            }
        }
        return fileSize
    }
    
    /// 是否是文件夹
    ///
    /// - Parameter atPath: 目录路径
    /// - Returns: true or false
    public class func isDirectory(atPath: String) -> Bool {
        var isDirectory: ObjCBool = ObjCBool(false)
        let fromExist = FileManager.default.fileExists(atPath: atPath,
                                                       isDirectory: &isDirectory)
        return fromExist && isDirectory.boolValue
    }
}
