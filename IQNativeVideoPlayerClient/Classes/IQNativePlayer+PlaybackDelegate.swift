//
//  NativeVideoPlaybackDelegate.swift
//  IQPlayerNativeController
//
//  Created by B0223972 on 17/05/22.
//

import Foundation
import IQVideoPlayer

extension IQNativePlayer: IQPlaybackOutputDelegate {
    
    /**
     * Called with the progress and duration of playback. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    public func playback(didProgressChangedTo progress: TimeInterval, duration: TimeInterval) {
        delegate?.playback(playerView: self, didProgressChangedTo: progress, withDuration: duration)
    }
    
    /**
     * Called with the progress and duration of playback. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    public func playback(didBufferChangedTo buffer: TimeInterval, duration: TimeInterval) {
        delegate?.playback(playerView: self, didBufferChangedTo: buffer, withDuration: duration)
    }
    
    /**
     * Called when player is ready to play AVPlayerItem instances.
     * Do not consider as player is going to play the content instantly
     */
    public func playbackPlayerReadyToPlay() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerReadyToPlay)
    }
    
    /**
     * Called when player item is ready to be played.
     * Indicates the player is ready start the playback
     */
    public func playbackPlayerItemReadyToPlay() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemReadyToPlay)
    }
    
    /**
     * Called when player item can no longer be played because of an error. The error is described by the value of
     * the IQPlayerItem's error property.
     * @param error
     * Indicates about the error which has recieved while playing the content.
     * Look for localized and debug description of the error for more clarity.
     */
    public func playback(playerItemFailedWithError error: Error?) {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemFailed(error))
    }
    
    /**
     * Indicates that the player can no longer play IQPlayerItem instances because of an error. The error is passed in
     * parameter, Look for localized and debug description of the error for more clarity.
     */
    public func playback(playerFailedWithError error: Error?) {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerFailed(error))
    }
    
    /**
     * Indicates that the status of the player is not yet known because it has not tried to load new media resources for
     * playback.
     */
    public func playbackPlayerStatusChangedToUnknown() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerUnknown)
    }
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    public func playbackPlayerItemStatusChangedToUnknown() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemUnknown)
    }
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    public func playbackStartedLoading() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemloading)
    }
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    public func playbackStartedPlaying() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemNotLoading)
    }
    
    /**
     * Indicates that the playback in player item has ended.
     */
    public func playbackDidEnd() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playbackEnded)
    }
    
    /**
     * Indicates that  player item media doesn’t arrive in time to continue playback.
     */
    public func playbackDidStalled() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemPlaybackStalled)
    }
    
    /**
     *
     These constants are the allowable values of AVPlayer's timeControlStatus property. This discussion pertains when automaticallyWaitsToMinimizeStalling is YES, the default setting, and exceptions are discussed in connection with automaticallyWaitsToMinimizeStalling.
     */
    public func playbackStatusDidChange(newStatus: IQPlaybackStatus) {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemPlaybackStatusDidChange(newStatus))
    }
    
    /**
     * indicates that playback has consumed all buffered media and that playback will stall or end
     */
    public func playbackBufferDidBecomeEmpty() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playbackBufferEmpty)
    }
    
    /**
     * indicates that playback buffer is not empty now
     */
    public func playbackBufferDidBecomeNonEmpty() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playbackBufferNotEmpty)
    }
    
    /**
     * This property reports that the data buffer used for playback has reach capacity.
     * Despite the playback buffer reaching capacity there might not exist sufficient statistical
     * data to support a playbackLikelyToKeepUp prediction of YES.
     */
    public func playbackBufferDidBecomeFull() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playbackBufferFull)
    }
    
    /**
     * indicates that playback buffer is not full now
     */
    public func playbackBufferDidBecomeNotFull() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playbackBufferNotFull)
    }
    
    /**
     * indicates that playback buffer is not full now
     */
    public func playbackLikelyToKeepUp() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playbackLikelyToKeepUp)
    }
    
    /**
     * indicates that playback buffer is not full now
     */
    public func playbackMediaSelectionDidChange() {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .mediaSelectionDidChange)
    }
    
    /**
     * indicates that a new access log entry has been added to IQPlayerItem
     */
    public func playbackDidRecievePlayerItem(accessLog: IQPlayerItemAccessLog) {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemNewAccessLogEntry(accessLog))
    }
    
    /**
     * indicates that a error log entry has been added to IQPlayerItem
     */
    public func playbackDidRecievePlayerItem(errorLog: IQPlayerItemErrorLog) {
        delegate?.playback(playerView: self, didReceivePlaybackLifeCycleEvent: .playerItemNewErrorLogEntry(errorLog))
    }
}





