# iCloudPicker

swift 版本
 
 特点：
 
 1、直接显示到 iCloud 云盘位置
 
 2、可以自定义主题颜色、（微信自定义了主题颜色）
 
 3、使用 UIDocument 来读写文件保证文件的安全访问
      
[https://github.com/xiaohuochai/iCloudPicker.git](https://github.com/xiaohuochai/iCloudPicker.git)


# Installation

## Using [CocoaPods](https://cocoapods.org):
Simply add the following line to your Podfile:
```  
pod 'ICloudPicker'
```
# Use
```
func openICloudDocumentPickerViewController() {
    guard ICloudManager.iCloudEnable() else {
      debugPrint("请在设置->AppleID、iCloud->iCloud中打开访问权限")
      return
    }

    let iCloudDocument = ICloudDocumentPickerViewController.init(documentTypes: ["public.data"], in: .open)
    iCloudDocument.themeColor = .red
    iCloudDocument.delegate = self
    self.present(iCloudDocument, animated: true) {}
}
```

```
extension ViewController: UIDocumentPickerDelegate {

  public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    saveiCloudDocument(urls)
  }

  public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
    saveiCloudDocument([url])
  }

  /// 保存文件、限制文件大小为10m
  ///
  /// - Parameter url: UIDocumentPicker url
  func saveiCloudDocument(_ urls: [URL]) {
    guard let url = urls.first else {
      return
    }
    ICloudManager.save(with: url, maxSize: 10*1024*1024) { (location, result, errorMsg) in

    }
  }
}
```

# Cache
```
func iCloudBoxCache() {

  // 异步获取 ICloudDocument 文件大小
  ICloudManager.asynciCloudBoxSize { (size) in
    debugPrint(size)

    // 清除所有 本地存储的 ICloudDocument 文件
    ICloudManager.cleariCloudBoxCache()

    // 清除单个文件
    // ICloudManager.cleariCloudBoxCache(filePath: URL.init(fileURLWithPath: ""))
   }
}
```
#  view
<img src="http://oo6oh08d7.bkt.clouddn.com/123456789.png" width = 30% height = 30% />
