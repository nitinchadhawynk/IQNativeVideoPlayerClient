//
//  IQPlayerItem+Live.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 08/04/22.
//

import Foundation
import CoreMedia

public extension IQPlayerItem {
    
    func getSeekableTimeRanges() -> [CMTimeRange]? {
        return av_playerItem?.seekableTimeRanges as? [CMTimeRange] ?? nil
    }
    
    func getDuration() -> Float {
        if isLiveContent {
            return getLiveDuration()
        } else {
            return Float(self.duration())
        }
    }
    
    func getLiveDuration() -> Float {
        var result : Float = 0.0;
        
        guard let items = av_playerItem?.seekableTimeRanges else {
            return result
        }
        
        if(!items.isEmpty) {
            let range = items[items.count - 1]
            let timeRange = range.timeRangeValue
            let startSeconds = CMTimeGetSeconds(timeRange.start)
            let durationSeconds = CMTimeGetSeconds(timeRange.duration)
            
            result = Float(startSeconds + durationSeconds)
        }
        return result
    }
}
