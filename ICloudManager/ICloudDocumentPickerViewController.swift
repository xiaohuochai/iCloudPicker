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
    var themeColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }
    
    /// 设置主题颜色
    ///
    /// - Parameter animated:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let themeColor = themeColor {
            UIImageView.appearance().tintColor = themeColor
            UITabBar.appearance().tintColor = themeColor
            UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = themeColor
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:themeColor], for: .normal)
            UILabel.appearance().tintColor = themeColor
            UIButton.appearance().tintColor = themeColor
            view.tintColor = themeColor
        }
    }
    
    /// 恢复系统主题颜色
    ///
    /// - Parameter animated:
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let _ = themeColor {
            let defaultTintColor: UIColor = .blue
            UIImageView.appearance().tintColor = defaultTintColor
            UITabBar.appearance().tintColor = defaultTintColor
            UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = defaultTintColor
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:defaultTintColor], for: .normal)
            UILabel.appearance().tintColor = defaultTintColor
            UIButton.appearance().tintColor = defaultTintColor
            view.tintColor = defaultTintColor
        }
    }
}
