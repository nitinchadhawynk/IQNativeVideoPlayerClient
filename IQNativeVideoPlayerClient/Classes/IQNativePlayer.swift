//
//  NativeVideoPlayerViewController.swift
//  IQPlayerNativeController
//
//  Created by B0223972 on 17/05/22.
//

import Foundation
import IQVideoPlayer
import AVKit

public class IQNativePlayer {
    
    public var iqPlayer: IQPlayer!
    
    public weak var delegate: IQNativeVideoPlayerOutput?
    
    public var nativePlayerViewController: AVPlayerViewController?
    
    public init(playerItem: IQPlayerItem) {
        self.iqPlayer = IQPlayer(playerItem: playerItem,
                                 outputDelegate: self,
                                 isPlayerViewRequired: false)
    }
    
    public init() {
        self.iqPlayer = IQPlayer(outputDelegate: self, initiatePlayerLayer: false)
    }
    
    public func instantiatePlayerViewController() -> AVPlayerViewController? {
        let playerViewController = AVPlayerViewController()
        guard let player = iqPlayer.getAVPlayerIfAvailable() else {
            return nil
        }
        self.nativePlayerViewController = playerViewController
        playerViewController.player = player
        return playerViewController
    }
    
    public func getAVPlayer() -> AVPlayer? {
        return self.iqPlayer.getAVPlayerIfAvailable()
    }
    
    public func addMetaDataToPlayer(metadata: Metadata) {
        nativePlayerViewController?.player?.currentItem?.externalMetadata = createMetadataItems(for: metadata)
    }
    
    private func createMetadataItems(for metadata: Metadata) -> [AVMetadataItem] {
        let mapping: [AVMetadataIdentifier: Any] = [
            .commonIdentifierTitle: metadata.title,
            .iTunesMetadataTrackSubTitle: metadata.subtitle,
            .commonIdentifierDescription: metadata.description,
            .commonIdentifierArtwork: metadata.image,
            .iTunesMetadataContentRating: metadata.rating,
            .quickTimeMetadataGenre: metadata.genre
        ]
        return mapping.compactMap { createMetadataItem(for:$0, value:$1) }
    }
    
    private func createMetadataItem(for identifier: AVMetadataIdentifier,
                                    value: Any) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }
    
    public func getPlayerAccessLog() -> AVPlayerItemAccessLog? {
       return self.iqPlayer.getAVPlayerIfAvailable()?.currentItem?.accessLog()
    }
}


