//
//  ViewController.swift
//  TVOS-SampleApplication
//
//  Created by B0223972 on 18/05/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import AVKit
import IQVideoPlayer
import IQNativeVideoPlayerClient

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
    
    
}

