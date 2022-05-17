//
//  IQPlayerVideoGravity.swift
//  IQVideoPlayer
//
//  Created by Nitin Chadha on 17/04/22.
//

import Foundation
import AVFoundation

public enum IQPlayerVideoGravity {
    
    /**
     * @constant IQVideoGravity.fill
     *
     * @abstract Used to stretch the content to fill the available space, it may distort the aspect size.
     *
     */
    case fill
    
    /**
     * @constant IQVideoGravity.aspectFit
     *
     * @abstract Used to scale the content with fixed aspect, remainder is transparent.
     *
     */
    case aspectFit
    
    /**
     * @constant IQVideoGravity.aspectFill
     *
     * @abstract Used to fill all the available space with fixed aspect, some portion of content may be clipped.
     *
     */
    case aspectFill
    
    internal var avGravity: AVLayerVideoGravity  {
        switch self {
        case .fill:
            return .resize
        case .aspectFit:
            return .resizeAspect
        case .aspectFill:
            return .resizeAspectFill
        }
    }
}
