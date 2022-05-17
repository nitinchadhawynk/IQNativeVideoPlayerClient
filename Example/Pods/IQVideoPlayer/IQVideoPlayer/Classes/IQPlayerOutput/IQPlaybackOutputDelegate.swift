//
//  IQPlaybackOutputDelegate.swift
//  Pods
//
//  Created by B0223972 on 17/05/22.
//

import Foundation

public protocol IQPlaybackOutputDelegate: AnyObject {
    
    /**
     * Called with the progress and duration of playback. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    func playback(didProgressChangedTo progress: TimeInterval, duration: TimeInterval)
    
    /**
     * Called with the progress and duration of playback. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    func playback(didBufferChangedTo buffer: TimeInterval, duration: TimeInterval)
    
    /**
     * Called when player is ready to play AVPlayerItem instances.
     * Do not consider as player is going to play the content instantly
     */
    func playbackPlayerReadyToPlay()
    
    /**
     * Called when player item is ready to be played.
     * Indicates the player is ready start the playback
     */
    func playbackPlayerItemReadyToPlay()
    
    /**
     * Called when player item can no longer be played because of an error. The error is described by the value of
     * the IQPlayerItem's error property.
     * @param error
     * Indicates about the error which has recieved while playing the content.
     * Look for localized and debug description of the error for more clarity.
     */
    func playback(playerItemFailedWithError error: Error?)
    
    /**
     * Indicates that the player can no longer play IQPlayerItem instances because of an error. The error is passed in
     * parameter, Look for localized and debug description of the error for more clarity.
     */
    func playback(playerFailedWithError error: Error?)
    
    /**
     * Indicates that the status of the player is not yet known because it has not tried to load new media resources for
     * playback.
     */
    func playbackPlayerStatusChangedToUnknown()
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    func playbackPlayerItemStatusChangedToUnknown()
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    
    func playbackStartedLoading()
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    
    func playbackStartedPlaying()
    
    /**
     * Indicates that the playback in player item has ended.
     */
    
    func playbackDidEnd()
    
    /**
     * Indicates that  player item media doesn’t arrive in time to continue playback.
     */
    func playbackDidStalled()
    
    /**
     *
     These constants are the allowable values of AVPlayer's timeControlStatus property. This discussion pertains when automaticallyWaitsToMinimizeStalling is YES, the default setting, and exceptions are discussed in connection with automaticallyWaitsToMinimizeStalling.
     */
    func playbackStatusDidChange(newStatus: IQPlaybackStatus)
    
    /**
     * indicates that playback has consumed all buffered media and that playback will stall or end
     */
    func playbackBufferDidBecomeEmpty()
    
    /**
     * indicates that playback buffer is not empty now
     */
    func playbackBufferDidBecomeNonEmpty()
    
    /**
     * This property reports that the data buffer used for playback has reach capacity.
     * Despite the playback buffer reaching capacity there might not exist sufficient statistical
     * data to support a playbackLikelyToKeepUp prediction of YES.
     */
    func playbackBufferDidBecomeFull()
    
    /**
     * indicates that playback buffer is not full now
     */
    func playbackBufferDidBecomeNotFull()
    
    /**
     * indicates that playback buffer is not full now
     */
    func playbackLikelyToKeepUp()
    
    /**
     * indicates that playback buffer is not full now
     */
    func playbackMediaSelectionDidChange()
    
    /**
     * indicates that a new access log entry has been added to IQPlayerItem
     */
    func playbackDidRecievePlayerItem(accessLog: IQPlayerItemAccessLog)
    
    /**
     * indicates that a error log entry has been added to IQPlayerItem
     */
    func playbackDidRecievePlayerItem(errorLog: IQPlayerItemErrorLog)
}





