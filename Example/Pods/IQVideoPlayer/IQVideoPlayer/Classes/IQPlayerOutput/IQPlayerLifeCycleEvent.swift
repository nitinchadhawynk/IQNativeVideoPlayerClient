//
//  IQPlayerLifeCycleEvent.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 06/04/22.
//

import Foundation

/**
 Indicates about all the possible event which can occur before or during the playback.
 Event might be related to IQPlayer or IQPlayerItem.
 */
public enum IQPlayerLifeCycleEvent {
    
    
    /**
     * @constant loading
     * indicates that the player item is loading, client should implement loader on this
     */
    case playerItemloading
    
    /**
     * @constant NotLoading
     * indicates that the player item is not loading, client should hide loader on this
     */
    case playerItemNotLoading
    
    /**
     * @constant     readyToPlay
     * Indicates that the player item is ready to be played.
     */
    case playerItemReadyToPlay
    
    /**
     * @constant     PlayerItemFailed
     * Indicates that the player item can no longer be played because of an error. The error is described by the value of
     * the IQPlayerItem's error property.
     * @parameter error
     * Indicates about the error which has recieved while playing the content.
     * Look for localized and debug description of the error for more clarity.
     */
    case playerItemFailed(Error?)
    
    /**
     * @constant     PlayerItemUnknown
     * Indicates that the status of the player item is not yet known because it has not tried to load new media resources
     * for playback.
     */
    case playerItemUnknown
    
    /**
     * @constant     PlayerReadyToPlay
     * Indicates that the player is ready to play AVPlayerItem instances. Do not consider as player is going to play the content instantly
     */
    case playerReadyToPlay
    
    /**
     * @constant     PlayerFailed
     * Indicates that the player can no longer play IQPlayerItem instances because of an error. The error is passed in
     * parameter, Look for localized and debug description of the error for more clarity.
     */
    case playerFailed(Error?)
    
    /**
     * @constant     PlayerUnknown
     * Indicates that the status of the player is not yet known because it has not tried to load new media resources for
     * playback.
     */
    case playerUnknown
    
    /**
     * @constant     playbackEnded
     * Indicates that the playback has completed.
     */
    case playbackEnded
    
    /**
     * @constant     playbackBufferEmpty
     * indicates that playback has consumed all buffered media and that playback will stall or end
     */
    case playbackBufferEmpty
    
    /**
     * @constant     playbackBufferNotEmpty
     * indicates that playback buffer is not empty now
     */
    case playbackBufferNotEmpty
    
    /**
     * @constant playbackBufferFull
     * @abstract Indicates that the internal media buffer is full and that further I/O is suspended.
     * @discussion This property reports that the data buffer used for playback has reach capacity.
     * Despite the playback buffer reaching capacity there might not exist sufficient statistical
     * data to support a playbackLikelyToKeepUp prediction of YES.
     */
    case playbackBufferFull
    
    /**
     * @constant playbackBufferFull
     * indicates that playback buffer is not full now
     */
    case playbackBufferNotFull
    
    /**
     * @constant playbackLikelyToKeepUp
     * Indicates whether the item will likely play through without stalling.
     * @discussion This property communicates a prediction of playability. Factors considered in this prediction
     * include I/O throughput and media decode performance. It is possible for playbackLikelyToKeepUp to
     *  indicate NO while the property playbackBufferFull indicates YES. In this event the playback buffer has
     *  reached capacity but there isn't the statistical data to support a prediction that playback is likely to
     *  keep up. It is left to the application programmer to decide to continue media playback or not.
     *  See playbackBufferFull below.
     */
    case playbackLikelyToKeepUp
    
    /**
     *  @constant playbackLikelyToKeepUp
     *  Indicates item might stall during the playback.
     */
    case playbackIsNotLikelyToKeepUp
    
    /**
     *  @constant outputObscuredDueToInsufficientExternalProtection
     *  Whether or not decoded output is being obscured due to insufficient external protection.
     
     *  @discussion
     *  The value of this property indicates whether the player is purposefully obscuring the visual output
     *  of the current item because the requirement for an external protection mechanism is not met by the
     *  current device configuration. It is highly recommended that clients whose content requires external
     *   protection observe this property and set the playback rate to zero and display an appropriate user
     *   interface when the value changes to YES. This property is key value observable.
     
     *   Note that the value of this property is dependent on the external protection requirements of the
     *   current item. These requirements are inherent to the content itself and cannot be externally specified.
     *   If the current item does not require external protection, the value of this property will be NO.
     */
    case playbackObscuredDueToInsufficientExternalProtection
    
    /**
     *  @constant
     *  A event that the system fires when a player item fails to play to its end time.
     */
    case playbackFailedToPlayTillEnd
    
    /**
     *  @constant
     *  A event the system fires when a player item plays to its end time.
     */
    case playbackPlayedTillEnd
    
    /**
     *  @constant
     *  A event the system fires when a player item media doesn’t arrive in time to continue playback.
     */
    case playerItemPlaybackStalled
    
    /**
     *   @constant
     *   A event the system posts when a player item adds a new entry to its access log.
     */
    case playerItemNewAccessLogEntry(IQPlayerItemAccessLog)
    
    /**
     *   @constant
     *   A event the system posts when a player item adds a new entry to its error log.
     */
    case playerItemNewErrorLogEntry(IQPlayerItemErrorLog)
    
    /**
     * @constant
     * A event the player item posts when its media selection changes.
     */
    case mediaSelectionDidChange
    
    /**
     * @constant
     * A event the player item posts when control status changes.
     */
    case playerItemPlaybackStatusDidChange(IQPlaybackStatus)
}
