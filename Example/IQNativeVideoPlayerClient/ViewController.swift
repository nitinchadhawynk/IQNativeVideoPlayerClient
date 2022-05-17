//
//  ViewController.swift
//  IQNativeVideoPlayerClient
//
//  Created by nitinchadhawynk on 05/17/2022.
//  Copyright (c) 2022 nitinchadhawynk. All rights reserved.
//

import UIKit
import IQNativeVideoPlayerClient
import IQVideoPlayer
import AVKit

class ViewController: UIViewController {

    var player: IQNativePlayer?
    var nativePlayerViewController: AVPlayerViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let url = URL(string: "https://bitdash-a.akamaihd.net/content/sintel/hls/playlist.m3u8") else { return }
            let item = IQPlayerItem(url: url)
            self.player = IQNativePlayer(playerItem: item)
            if let vc = self.player?.nativePlayerViewController {
                self.present(vc, animated: true, completion: nil)
                self.nativePlayerViewController = vc
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

