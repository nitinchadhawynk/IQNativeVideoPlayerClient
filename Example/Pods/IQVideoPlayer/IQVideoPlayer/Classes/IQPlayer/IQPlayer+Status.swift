//
//  IQPlayer+Status.swift
//  IQVideoPlayer
//
//  Created by B0223972 on 12/04/22.
//

import Foundation
import AVFoundation

/**
 * Indicates about all the possible playback status which can occur in the playback.
 */
public enum IQPlaybackStatus {
    
    /**
     * @constant playing
     * In this state, playback is currently progressing and rate changes will take effect immediately.
     */
    case playing

    /**
     * @constant paused
     * This state is entered upon receipt of a -pause message, an invocation of -setRate: with a value of 0.0,
     * when a change in overall state requires playback to be halted
     */
    case paused

    /**
     * @constant waiting
     * indicates that the player is waiting for buffering 
     */
    case waiting
    
    /**
     * @constant waiting
     */
    case unknown
    
    /**
     * @constant stopped
     * indicates that the player is stopped, this is user generated status
     */
    case stopped
}


extension IQPlayer {
    
    func playbackStatus() -> IQPlaybackStatus {
        return convertTimeControlStatus(status: av_player.timeControlStatus)
    }
    
    private func convertTimeControlStatus(status: AVPlayer.TimeControlStatus) -> IQPlaybackStatus {
        
        switch status {
        case .playing:
            return .playing
            
        case .paused:
            return .paused
            
        case .waitingToPlayAtSpecifiedRate:
            return .waiting
            
        @unknown default:
            return .unknown
        }
    }
}
