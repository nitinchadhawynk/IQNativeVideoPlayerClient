//
//  IQPlaybackOutputManager.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 05/04/22.
//

import UIKit

/**
 * The IQPlaybackOutputManager class provides special handling of different consumer clients
 * and helps in dispatching any event to all the observers.
 */
internal class IQPlaybackOutputManager: IQPlaybackOutputDelegate {
    
    /**
     * listeners is the array of all the clients who are observing the playback events.
     * if any event is dispatched by player, then all the listeneres will get notified.
     */
    private var listeners = [IQWeakPlayerPlaybackConsumer]()
    
    /**
     * playerView is used to pass as reference while dispatching
     * any action to the observer.
     */
    private weak var playerView: IQPlayerView?
    
    /**
     * Initializes a IQPlaybackOutputManager. It uses the playerView
     * to keep the reference, pass it to different listeners.
     *
     * @param playerView IQPlayerView to be passed with action
     * @return An initialized instance.
     */
    init(playerView: IQPlayerView) {
        self.playerView = playerView
    }
    
    /**
     * Take a listener as parameter and add that listener
     * into collection of listeners
     *
     * @param listener consumer we want to inform in case of any
     * event dispatch from player
     */
    public func append(listener: IQPlayerViewOutput) {
        listeners.append(IQWeakPlayerPlaybackConsumer(listener))
    }
    
    /**
     * Remove IQPlayerPlaybackConsumer instance from delegate Array
     *
     * @param listener consumer we want to remove
     */
    public func remove(listener: IQPlayerViewOutput) {
        self.listeners = listeners.filter({ $0.value !== listener })
    }
    
    /**
     * Called with the progress and duration of playback. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    func playback(didProgressChangedTo progress: TimeInterval, duration: TimeInterval) {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didProgressChangedTo: progress, withDuration: duration)
        }
    }
    
    /**
     * Called with the progress and duration of playback. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    func playback(didBufferChangedTo buffer: TimeInterval, duration: TimeInterval) {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didBufferChangedTo: buffer, withDuration: duration)
        }
    }
    
    /**
     * Called when player is ready to play AVPlayerItem instances.
     * Do not consider as player is going to play the content instantly
     */
    func playbackPlayerReadyToPlay() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerReadyToPlay)
        }
    }
    
    /**
     * Called when player item is ready to be played.
     * Indicates the player is ready start the playback
     */
    func playbackPlayerItemReadyToPlay() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemReadyToPlay)
        }
    }
    
    /**
     * Called when player item can no longer be played because of an error. The error is described by the value of
     * the IQPlayerItem's error property.
     * @param error
     * Indicates about the error which has recieved while playing the content.
     * Look for localized and debug description of the error for more clarity.
     */
    func playback(playerItemFailedWithError error: Error?) {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemFailed(error))
        }
    }
    
    /**
     * Indicates that the player can no longer play IQPlayerItem instances because of an error. The error is passed in
     * parameter, Look for localized and debug description of the error for more clarity.
     */
    func playback(playerFailedWithError error: Error?) {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerFailed(error))
        }
    }
    
    /**
     * Indicates that the status of the player is not yet known because it has not tried to load new media resources for
     * playback.
     */
    func playbackPlayerStatusChangedToUnknown() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerUnknown)
        }
    }
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    func playbackPlayerItemStatusChangedToUnknown() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemUnknown)
        }
    }
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    func playbackStartedLoading() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemloading)
        }
    }
    
    /**
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    func playbackStartedPlaying() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemNotLoading)
        }
    }
    
    /**
     * Indicates that the playback in player item has ended.
     */
    func playbackDidEnd() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playbackEnded)
        }
    }
    
    /**
     * Indicates that  player item media doesn’t arrive in time to continue playback.
     */
    func playbackDidStalled() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemPlaybackStalled)
        }
    }
    
    /**
     *
     These constants are the allowable values of AVPlayer's timeControlStatus property. This discussion pertains when automaticallyWaitsToMinimizeStalling is YES, the default setting, and exceptions are discussed in connection with automaticallyWaitsToMinimizeStalling.
     */
    func playbackStatusDidChange(newStatus: IQPlaybackStatus) {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemPlaybackStatusDidChange(newStatus))
        }
    }
    
    /**
     * indicates that playback has consumed all buffered media and that playback will stall or end
     */
    func playbackBufferDidBecomeEmpty() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playbackBufferEmpty)
        }
    }
    
    /**
     * indicates that playback buffer is not empty now
     */
    func playbackBufferDidBecomeNonEmpty() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playbackBufferNotEmpty)
        }
    }
    
    /**
     * This property reports that the data buffer used for playback has reach capacity.
     * Despite the playback buffer reaching capacity there might not exist sufficient statistical
     * data to support a playbackLikelyToKeepUp prediction of YES.
     */
    func playbackBufferDidBecomeFull() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playbackBufferFull)
        }
    }
    
    /**
     * indicates that playback buffer is not full now
     */
    func playbackBufferDidBecomeNotFull() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playbackBufferNotFull)
        }
    }
    
    /**
     * indicates that playback buffer is not full now
     */
    func playbackLikelyToKeepUp() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playbackLikelyToKeepUp)
        }
    }
    
    /**
     * indicates that playback buffer is not full now
     */
    func playbackMediaSelectionDidChange() {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .mediaSelectionDidChange)
        }
    }
    
    /**
     * indicates that a new access log entry has been added to IQPlayerItem
     */
    func playbackDidRecievePlayerItem(accessLog: IQPlayerItemAccessLog) {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemNewAccessLogEntry(accessLog))
        }
    }
    
    /**
     * indicates that a error log entry has been added to IQPlayerItem
     */
    func playbackDidRecievePlayerItem(errorLog: IQPlayerItemErrorLog) {
        guard let view = playerView else { return }
        listeners.compactMap({ $0.value }).forEach {
            $0.playback(playerView: view, didReceivePlaybackLifeCycleEvent: .playerItemNewErrorLogEntry(errorLog))
        }
    }
}




