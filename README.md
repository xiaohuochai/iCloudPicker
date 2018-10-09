# iCloudPicker
UIDocumentPickerViewController

[https://github.com/xiaohuochai/iCloudPicker.git](https://github.com/xiaohuochai/iCloudPicker.git)

# use
```func openICloudDocumentPickerViewController() {
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
#  view
<img src="http://oo6oh08d7.bkt.clouddn.com/123456789.png" width = 30% height = 30% />

![效果](http://oo6oh08d7.bkt.clouddn.com/123456789.png)

