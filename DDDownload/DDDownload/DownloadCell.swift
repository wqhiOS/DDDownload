//
//  DownloadCell.swift
//  DDDownload
//
//  Created by wuqh on 2018/12/11.
//  Copyright © 2018 wuqh. All rights reserved.
//

import UIKit

class DownloadCell: UITableViewCell {
    
    var url:String? {
        didSet {
            guard let url = url else {
                return
            }
            NotificationCenter.default.addObserver(forName: NSNotification.Name.init(url.md5), object: nil, queue: OperationQueue.main) { (nf) in
                if let progress = nf.userInfo?["progress"] as? Float {
                    self.slider.value = progress
                }
            }
        }
    }
    var clickButton:((UIButton)->())?

    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 0.1, height: 0.1), false, UIScreen.main.scale)
        UIRectFill(CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        slider.setThumbImage(img, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        clickButton?(sender)
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func deleteButtonClick(_ sender: UIButton) {
       try? FileManager.default.removeItem(atPath: DDDownloadManager.downloadFilePath(url!).path)
    }
    
}
