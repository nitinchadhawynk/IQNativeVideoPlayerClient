//
//  IQDefaultPlayerMetrics.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 05/04/22.
//

import Foundation

protocol IQPlayerPerformanceDelegate: AnyObject {
    
    func playbackDidStalled()
    
    func playback(didStallForMilliSeconds milliSeconds: Int64)
}

public class IQPlayerPerformance {
    
    // Used to caclulate stall duration
    fileprivate var stallBeginTime:Int64 = 0
    
    // Last observed bitrate
    fileprivate var lastBitrate:Double = 0
    
    var isStalling: Bool = false
    
    private weak var delegate: IQPlayerPerformanceDelegate?
    
    init(delegate: IQPlayerPerformanceDelegate) {
        self.delegate = delegate
    }
}

extension IQPlayerPerformance: IQPlayerViewOutput {
    
    public func playback(playerView: IQPlayerView,
                         didProgressChangedTo progress: TimeInterval,
                         withDuration duration: TimeInterval) {
        
    }
    
    public func playback(playerView: IQPlayerView,
                         didReceivePlaybackLifeCycleEvent event: IQPlayerLifeCycleEvent) {
        
        switch event {
        
        case .playerItemPlaybackStalled:
            self.stallBeginTime = Date().toMillis()
            delegate?.playbackDidStalled()
            
        
        case .playbackLikelyToKeepUp:
            if isStalling {
                let stallDurationMs: Int64 = Date().toMillis() - stallBeginTime
                delegate?.playback(didStallForMilliSeconds: stallDurationMs)
            }
            
        default:
            break
        }
    }
}
