//
//  IQPlayer+ErrorLog.swift
//  IQVideoPlayer
//
//  Created by Nitin Chadha on 12/04/22.
//

import AVFoundation

/**
 * An IQPlayerItemAccessLog provides named properties for accessing the data
 * fields of each log event. None of the properties of this class are observable.
 */
public struct IQPlayerItemErrorLog {
    
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
     @property        errorStatusCode
     @abstract        A unique error code identifier.
     @discussion    Corresponds to "status".
     This property is not observable.
     */
    public let errorStatusCode: Int
    
    /**
     @property        errorDomain
     @abstract        The domain of the error.
     @discussion    Corresponds to "domain".
     This property is not observable.
     */
    public let errorDomain: String
    
    /**
     @property        errorComment
     @abstract        A description of the error encountered. Can be nil.
     @discussion    If nil is returned further information is not available. Corresponds to "comment".
     This property is not observable.
     */
    public let errorComment: String?
    
    /**
     @property        date
     @abstract        The date and time when the error occured. Can be nil.
     @discussion    If nil is returned the date is unknown. Corresponds to "date".
     This property is not observable.
     */
    public let date: Date?
    
    /**
     * Initialise IQPlayerAccessLog with AVPlayerItemAccessLogEvent
     */
    init(event: AVPlayerItemErrorLogEvent) {
        self.uri = event.uri
        self.sessionID = event.playbackSessionID
        self.date = event.date
        self.errorStatusCode = event.errorStatusCode
        self.errorDomain = event.errorDomain
        self.errorComment = event.errorComment
    }
}
