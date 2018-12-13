//
//  PlayerViewController.swift
//  DDDownload
//
//  Created by wuqh on 2018/12/12.
//  Copyright © 2018 wuqh. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    private lazy var playerView: DDPlayerView = {
        let playerView = DDPlayerView(frame: CGRect(x: 0, y: 200, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 9 / 16))
        return playerView
    }()
    
    var url: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        view.addSubview(playerView)
        playerView.player.play(withUrl: url)
   }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        playerView.player.stop()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
