//
//  IQPlayerItem+Bitrates.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 08/04/22.
//

import Foundation
import UIKit

public struct IQPlayerBitrateVariant {
    var bitrate: Int
    var resolution: String?
}

extension IQPlayerItem {
    
    public func observeBitrates() -> [IQPlayerBitrateVariant] {
        let builder = ManifestBuilder().parse(url)
        let playlist = builder.playlists
        
        var availableVariants = [IQPlayerBitrateVariant]()
        for object in playlist {
            if object.bandwidth > 0 {
                availableVariants.append(IQPlayerBitrateVariant(bitrate: object.bandwidth, resolution: object.resolution))
            }
        }
        return availableVariants
    }
    
    func setPreferredPeakBitrate(bitrate: Double) {
        self.av_playerItem?.preferredPeakBitRate = bitrate
    }
    
    func setPreferredMaximumResolution(resolution: CGSize) {
        self.av_playerItem?.preferredMaximumResolution = resolution
    }
}
