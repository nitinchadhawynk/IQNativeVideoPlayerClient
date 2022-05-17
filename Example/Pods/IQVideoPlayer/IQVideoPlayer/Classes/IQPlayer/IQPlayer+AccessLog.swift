//
//  IQPlayer+AccessLog.swift
//  IQVideoPlayer
//
//  Created by Nitin Chadha on 12/04/22.
//

import Foundation
import AVFoundation

/**
 * An IQPlayerItemAccessLog provides named properties for accessing the data
 * fields of each log event. None of the properties of this class are observable.
 */
public struct IQPlayerItemAccessLog {
    
    /**
     @property        URI
     @abstract        The URI of the playback item. Can be nil.
     @discussion    If nil is returned the URI is unknown. Corresponds to "uri".
     This property is not observable.
     */
    public let uri: String?
    
    /**
     @property        playbackSessionID
     @abstract        A GUID that identifies the playback session. This value is used in HTTP requests. Can be nil.
     @discussion    If nil is returned the GUID is unknown. Corresponds to "cs-guid".
     This property is not observable.
     */
    public let sessionID: String?
    
    /**
     @property        playbackStartDate
     @abstract        The date/time at which playback began for this event. Can be nil.
     @discussion    If nil is returned the date is unknown. Corresponds to "date".
     This property is not observable.
     */
    public let startDate: Date?
    
    /**
     @property        playbackStartOffset
     @abstract        An offset into the playlist where the last uninterrupted period of playback began. Measured in seconds.
     @discussion    Value is negative if unknown. Corresponds to "c-start-time".
     This property is not observable.
     */
    public let playbackStartOffset: TimeInterval?
    
    /**
     @property        playbackType
     @abstract        Playback type (LIVE, VOD, FILE).
     @discussion    If nil is returned the playback type is unknown. Corresponds to "s-playback-type".
     This property is not observable.
     */
    public let playbackType: String?
    
    /**
     @property        indicatedBitrate
     @abstract        The throughput required to play the stream, as advertised by the server. Measured in bits per second.
     @discussion    Value is negative if unknown. Corresponds to "sc-indicated-bitrate".
     This property is not observable.
     */
    public let indicatedBytes: String?
    
    /**
     @property        observedBitrate
     @abstract        The empirical throughput across all media downloaded. Measured in bits per second.
     @discussion    Value is negative if unknown. Corresponds to "c-observed-bitrate".
     This property is not observable.
     */
    public let observedBytes: String?
    
    /**
     @property        startupTime
     @abstract        The accumulated duration until player item is ready to play. Measured in seconds.
     @discussion    Value is negative if unknown. Corresponds to "c-startup-time".
     This property is not observable.
     */
    public let startupTime: TimeInterval?
    
    /**
     @property        durationWatched
     @abstract        The accumulated duration of the media played. Measured in seconds.
     @discussion    Value is negative if unknown. Corresponds to "c-duration-watched".
     This property is not observable.
     */
    public let durationWatched: TimeInterval?
    
    /**
     @property        numberOfDroppedVideoFrames
     @abstract        The total number of dropped video frames.
     @discussion    Value is negative if unknown. Corresponds to "c-frames-dropped".
     This property is not observable.
     */
    public let numberOfDroppedVideoFrames: Int?
    
    /**
     @property        numberOfStalls
     @abstract        The total number of playback stalls encountered.
     @discussion    Value is negative if unknown. Corresponds to "c-stalls".
     This property is not observable.
     */
    public let numberOfStalls: Int?
    
    /**
     @property        downloadOverdue
     @abstract        The total number of times the download of the segments took too long.
     @discussion    Value is negative if unknown. Corresponds to "c-overdue".
     This property is not observable.
     */
    public let downloadOverdue: Int?
    
    /**
     @property        segmentsDownloadedDuration
     @abstract        The accumulated duration of the media downloaded. Measured in seconds.
     @discussion    Value is negative if unknown. Corresponds to "c-duration-downloaded".
     This property is not observable.
     */
    public let segmentsDownloadedDuration: TimeInterval?
    
    /**
     * Initialise IQPlayerAccessLog with AVPlayerItemAccessLogEvent
     */
    init(event: AVPlayerItemAccessLogEvent) {
        self.uri = event.uri
        self.sessionID = event.playbackSessionID
        self.startDate = event.playbackStartDate
        self.playbackStartOffset = event.playbackStartOffset
        self.playbackType = event.playbackType
        self.indicatedBytes = bytesToHumanReadable(bytes: event.indicatedBitrate)
        self.observedBytes = bytesToHumanReadable(bytes: event.observedBitrate)
        self.startupTime = event.startupTime
        self.durationWatched = event.durationWatched
        self.numberOfDroppedVideoFrames = event.numberOfDroppedVideoFrames
        self.numberOfStalls = event.numberOfStalls
        self.downloadOverdue = event.downloadOverdue
        self.segmentsDownloadedDuration = event.segmentsDownloadedDuration
    }
}
