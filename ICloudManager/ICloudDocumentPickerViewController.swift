//
//  ICloudDocumentPickerViewController.swift
//  cloud
//
//  Created by Teng Wang 王腾 on 2018/10/9.
//  Copyright © 2018 Teng Wang 王腾. All rights reserved.
//

import UIKit

public class ICloudDocumentPickerViewController: UIDocumentPickerViewController {
    
    /// 主题颜色
    public var themeColor: UIColor?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }
    
    /// 设置主题颜色
    ///
    /// - Parameter animated:
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let themeColor = themeColor {
           configureThemeColor(themeColor)
        }
    }
    
    /// 恢复系统主题颜色
    ///
    /// - Parameter animated:
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = themeColor {
            configureThemeColor(.blue)
        }
    }
    
    /// 设置主题颜色
    ///
    /// - Parameter themeColor:
    func configureThemeColor(_ themeColor: UIColor) {
        UIImageView.appearance().tintColor = themeColor
        UITabBar.appearance().tintColor = themeColor
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = themeColor
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:themeColor], for: .normal)
        UILabel.appearance().tintColor = themeColor
        UIButton.appearance().tintColor = themeColor
        view.tintColor = themeColor
    }
}
