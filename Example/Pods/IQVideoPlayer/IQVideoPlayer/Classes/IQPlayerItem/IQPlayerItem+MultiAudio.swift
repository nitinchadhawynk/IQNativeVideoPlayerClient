//
//  IQPlayerItem+MultiAudio.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 07/04/22.
//

import Foundation
import AVFoundation

public struct IQAudio {
    public let languageCode: String
    public let displayName: String
}

public extension IQPlayerItem {
    
    private func fetchGroupNameForMultiAudio() -> AVMediaSelectionGroup? {
        for characteristic in av_asset.availableMediaCharacteristicsWithMediaSelectionOptions where characteristic == .audible {
            return av_asset.mediaSelectionGroup(forMediaCharacteristic: characteristic)
        }
        return nil
    }
    
    func select(audio: IQAudio) {
        guard let group = fetchGroupNameForMultiAudio() else { return }
        for option in group.options where option.extendedLanguageTag?.lowercased() == audio.languageCode.lowercased() {
            av_playerItem?.select(option, in: group)
        }
    }
    
    func getAvailableAudios() -> [IQAudio]? {
        guard let group = fetchGroupNameForMultiAudio() else {
            return nil
        }
        
        var availableAudios = [IQAudio]()
        for option in group.options where option.extendedLanguageTag != nil {
            if let languageTag = option.extendedLanguageTag {
                availableAudios.append(IQAudio(languageCode: languageTag, displayName: option.displayName))
            }
        }
        return availableAudios.isEmpty ? nil : availableAudios
    }
    
    func selectedAudio() -> IQAudio? {
        guard let group = fetchGroupNameForMultiAudio() else { return nil }
        guard let option = av_playerItem?.currentMediaSelection.selectedMediaOption(in: group),
              let languageTag = option.extendedLanguageTag else { return nil }
        return IQAudio(languageCode: languageTag, displayName: option.displayName)
    }
}
