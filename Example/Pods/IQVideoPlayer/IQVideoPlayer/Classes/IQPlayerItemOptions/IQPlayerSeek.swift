//
//  IQPlayerSeek.swift
//  IQVideoPlayer
//
//  Created by Nitin Chadha on 17/04/22.
//

import Foundation

public enum IQPlayerSeek {
    
    /**
     * @constant IQPlayerSeek.position
     *
     * @parameter TimeInterval
     *
     * @abstract Used to set the constant duration limit on seek foward or backward.
     *
     */
    case position(TimeInterval)
    
    /**
     * @constant IQPlayerSeek.durationRatio
     *
     * @parameter Float
     *
     * @abstract Used to set the ratio with total duration on seek foward or backward.
     *
     */
    case durationRatio(Float)
}
