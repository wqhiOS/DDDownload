//
//  DownloadViewController.swift
//  DDDownload
//
//  Created by wuqh on 2018/12/11.
//  Copyright © 2018 wuqh. All rights reserved.
//

import UIKit



class DownloadViewController: UIViewController {
    
    deinit {
        print(#function)
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "DownloadCell", bundle: nil), forCellReuseIdentifier: DownloadCell.description())
        tableView.rowHeight = 120
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "下载"
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        
        DDDownloadManager.default.setup()
    }

}

extension DownloadViewController: UITableViewDataSource,UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DownloadCell.description(), for: indexPath) as! DownloadCell
        cell.clickButton = {(button) in
            if button.isSelected {
                DDDownloadManager.default.cancelDownload(withUrl: urls[indexPath.row])
            }else {
                DDDownloadManager.default.download(withUrl: urls[indexPath.row])
            }
            
        }
        cell.url = urls[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewController()
        vc.url = DDDownloadManager.downloadFilePath(urls[indexPath.row]).path
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


let urls = ["http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201811/82393f5ce70745bea85701ddaab447b5_512.mp4",
            "http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201811/94f5c04bd2164d4e9d77d6cb8a7de87e_512.mp4",
            "http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201811/9e2462f0a54e474e83c005d8989d52c1_512.mp4",
            "http://alivideo.g2s.cn/zhs_yanfa_150820/createcourse/demo/201811/bad0d13346314014a8aa3197352c7f43_512.mp4"]
