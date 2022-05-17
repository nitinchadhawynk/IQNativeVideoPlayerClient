//
//  IQPlayableAction.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import AVKit

public protocol IQPlayerControlActionDelegate {
    
    var isMuted: Bool { get set }
    func play()
    func pause()
}

public protocol IQVideoPlayerInterface {
    func play()
    func pause()
    func seek(to time: TimeInterval)
    
    var isMuted: Bool { get set }
}
