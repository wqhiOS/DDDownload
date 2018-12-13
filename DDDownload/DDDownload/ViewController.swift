//
//  ViewController.swift
//  DDDownload
//
//  Created by wuqh on 2018/12/11.
//  Copyright © 2018 wuqh. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(DownloadViewController(), animated: true)
        }else {
            self.navigationController?.pushViewController(MyDownloadViewController(), animated: true)
        }
    }

}

