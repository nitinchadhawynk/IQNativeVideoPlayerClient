//
//  IQPlayerItemOptions.swift
//  IQVideoPlayer
//
//  Created by Nitin Chadha on 17/04/22.
//

import Foundation

public protocol IQPlayerItemOptionsProtocol {
    
    var playbackProgressInterval: TimeInterval { get set }
    
    var seekForward: IQPlayerSeek { get set }
        
    var seekBackward: IQPlayerSeek { get set }
    
    var isPlayerLoaderEnabled: Bool { get set }
}


public struct IQPlayerItemOptions: IQPlayerItemOptionsProtocol {
    
    public var playbackProgressInterval: TimeInterval = 0.5
    
    public var seekForward: IQPlayerSeek = .position(10.0)
    
    public var seekBackward: IQPlayerSeek = .position(10.0)
    
    public var isPlayerLoaderEnabled: Bool = true
    
}
