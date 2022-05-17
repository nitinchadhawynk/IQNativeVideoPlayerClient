//
//  IQPlayerItem.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import AVFoundation

/**
 * An IQPlayerItem carries a reference to a content as well as presentation settings for that asset.
 */
public class IQPlayerItem: NSObject {
    
    //MARK: Public Properties
    /**
     * An instance of URL that references a media resource.
     */
    public var url: URL
    
    /**
     * Bool value to indicate whether client wants player to play the content as soon it is ready to play.
     */
    public var isAutoPlayEnabled = true
    
    /**
     * Client should set isLive to true if content is live
     */
    public var isLiveContent = false
    
    /**
     * Used to alter the settings of IQPlayerItem
     */
    public var options: IQPlayerItemOptionsProtocol = IQPlayerItemOptions()
    
    /**
     * Any custom property for content can be set here
     */
    public var content: Any?
    
    //MARK: Internal Properties
    /**
     * Indicates if playerItem is ready to use and asset loaded properly
     */
    public var isPlayerItemReady = false
        
    /**
     * playerItemReadyCompletion is used to call all the blocks on getting PlayerItemReady
     */
    public var playerItemReadyCompletion = [(Bool) -> Void]()
    
    /**
     * Indicates the media duration the caller prefers the player to buffer from the network ahead of the playhead to guard against playback disruption. *
     */
    public var preferredForwardBufferDuration: TimeInterval {
        set { av_playerItem?.preferredForwardBufferDuration = newValue }
        get { return av_playerItem?.preferredForwardBufferDuration ?? 0 }
    }
    
    /**
     * An instance IQPlaybackOutputManager uses to inform all the observers about the any event related to playback.
     */
    var outputManager: IQPlaybackOutputManager?
    
    /**
     * An instance of AVPlayerItem
     */
    var av_playerItem: AVPlayerItem?
    
    /**
     * An instance of AVURLAsset
     */

    var av_asset: AVURLAsset
    
    /**
     * An instance of IQAssetLoader used to handle DRM content callbacks
     */
    var assetLoader: IQAssetLoader
    
    //MARK: PRIVATE PROPERTIES
    let headers: [String: Any]?
    
    /**
     @method        initWithURL:
     @abstract        Initializes an IQPlayerItem with an URL and headers.
     @param            URL
     @param            [String: Any]?
     @result        An instance of IQPlayerItem
     */

    public init(url: URL, headers: [String: Any]? = nil) {
        self.url = url
        self.headers = headers
        
        if let headers = headers {
            self.av_asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
        } else {
            self.av_asset = AVURLAsset(url: url, options: nil)
        }
        
        self.assetLoader = IQAssetLoader(asset: av_asset)
        
        super.init()
        
        self.loadValuesAsynchronously()
    }
    
    private func loadValuesAsynchronously() {
        self.av_asset.loadValuesAsynchronously(forKeys: ["tracks"]) {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let status = strongSelf.av_asset.statusOfValue(forKey: "tracks", error: nil)
                if status == .loaded {
                    strongSelf.av_playerItem = AVPlayerItem(asset: strongSelf.av_asset)
                    strongSelf.playerItemReadyCompletion.forEach( { $0(true) })
                    strongSelf.isPlayerItemReady = true
                    strongSelf.playerItemReadyCompletion.removeAll()
                } else {
                    strongSelf.playerItemReadyCompletion.forEach( { $0(false) })
                    strongSelf.isPlayerItemReady = false
                }
            }
        }
    }
    
    /// This can be used to add delegate for AssetLoader
    /// - Parameter delegate: Instance of class/struct confirming IQAssetLoaderDelegate
    public func setAssetLoaderDelegate(delegate: IQAssetLoaderDelegate) {
        self.assetLoader.delegate = delegate
    }
    
    /// The value of property provides the duration of asset
    /// - Returns: TimeInterval
    public func duration() -> TimeInterval {
        guard let duration = av_playerItem?.asset.duration, !duration.seconds.isNaN else {
            return 0
        }
        return CMTimeGetSeconds(duration)
    }
    
    func liveDuration() -> TimeInterval? {
        if let range = getSeekableTimeRanges(), let endRange = range.last {
            return CMTimeGetSeconds(endRange.end)
        } else {
            return nil
        }
    }
    
    func seekForwardTimeInterval() -> TimeInterval {
        switch options.seekForward {
        case .durationRatio(let ratio):
            return duration() * Double(ratio)
        case .position(let position):
            return position
        }
    }
    
    func seekBackwardTimeInterval() -> TimeInterval {
        switch options.seekBackward {
        case .durationRatio(let ratio):
            return duration() * Double(ratio)
        case .position(let position):
            return position
        }
    }
    
    deinit {
        print("IQVideoPlayer - IQPlayerItem Deallocated")
    }
}
