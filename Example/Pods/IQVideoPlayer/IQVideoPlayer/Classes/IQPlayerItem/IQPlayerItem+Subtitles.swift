//
//  IQPlayerItem+Subtitles.swift
//  IQPlayerSDK
//
//  Created by B0223972 on 08/04/22.
//

import Foundation
import AVFoundation

public struct IQSubtitle {
    public let languageCode: String
    public let displayName: String
}

public extension IQPlayerItem {
    
    private func fetchGroupNameForSubtitles() -> AVMediaSelectionGroup? {
        for characteristic in av_asset.availableMediaCharacteristicsWithMediaSelectionOptions where characteristic == .legible {
            return av_asset.mediaSelectionGroup(forMediaCharacteristic: characteristic)
        }
        return nil
    }
    
    func select(subtitle: IQSubtitle) {
        guard let group = fetchGroupNameForSubtitles() else { return }
        for option in group.options where option.extendedLanguageTag?.lowercased() == subtitle.languageCode.lowercased() {
            av_playerItem?.select(option, in: group)
        }
    }
    
    func getAvailableSubtitles() -> [IQSubtitle]? {
        guard let group = fetchGroupNameForSubtitles() else {
            return nil
        }
        
        var availableAudios = [IQSubtitle]()
        for option in group.options where option.extendedLanguageTag != nil {
            if let languageTag = option.extendedLanguageTag {
                availableAudios.append(IQSubtitle(languageCode: languageTag, displayName: option.displayName))
            }
        }
        return availableAudios.isEmpty ? nil : availableAudios
    }
    
    func selectedSubtitle() -> IQSubtitle? {
        guard let group = fetchGroupNameForSubtitles() else { return nil }
        guard let option = av_playerItem?.currentMediaSelection.selectedMediaOption(in: group),
              let languageTag = option.extendedLanguageTag else { return nil }
        return IQSubtitle(languageCode: languageTag, displayName: option.displayName)
    }
}
