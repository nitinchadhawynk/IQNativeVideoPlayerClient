//
//  IQNativeVideoPlayerOutput.swift
//  IQNativeVideoPlayerClient
//
//  Created by B0223972 on 18/05/22.
//

import Foundation
import IQVideoPlayer

/**
 * Conform to this protocol to receive basic playback information for each session.
 */
public protocol IQNativeVideoPlayerOutput: AnyObject {
    
    /**
     * Called with the playerView's playback progress. As the player
     * media plays, this method is called periodically with the latest progress
     * interval. We can configure the callback intervals from IQPlayerItemOptions
     *
     * @param view The playerview making progress.
     * @param progress The time interval of the session's current playback progress.
     * @param duration The complete time duration of the current playback.
     */
    func playback(playerView: IQNativePlayer, didProgressChangedTo progress: TimeInterval, withDuration duration: TimeInterval)
    
    /**
     * Called with the playerView's buffer progress. As the player
     * media plays, this method is called whenever progress of buffer is changed.
     *
     * @param view The playerview making buffer progress.
     * @param progress The time interval of the session's current buffer progress.
     * @param duration The complete time duration of the current playback.
     */
    func playback(playerView: IQNativePlayer, didBufferChangedTo buffer: TimeInterval, withDuration duration: TimeInterval)
    
    /**
     * Called when a playback session receives a lifecycle event. This method is
     * called only for lifecycle events that occur after the delegate is set
     *
     * The lifecycle event types are listed along with the
     * IQPlayerLifeCycleEvent enum.
     *
     * @param view The playerView whose lifecycle events were received.
     * @param lifecycleEvent The lifecycle event received from the player.
     */
    func playback(playerView: IQNativePlayer, didReceivePlaybackLifeCycleEvent event: IQPlayerLifeCycleEvent)
    
}
