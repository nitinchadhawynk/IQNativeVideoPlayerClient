//
//  IQPlayer.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import AVKit
import AVFoundation

public class IQPlayer: NSObject {
    
    private(set) var playerItem: IQPlayerItem
    
    private let av_playerLayer: AVPlayerLayer?
    
    @objc let av_player: AVPlayer
    
    weak var outputDelegate: IQPlaybackOutputDelegate?
    
    var currentTime: Double {
        return CMTimeGetSeconds(av_player.currentTime())
    }
    
    //MARK: IQPlayerLayerDelegate
    public var layer: CALayer? {
        return av_playerLayer
    }
    
    var isMuted: Bool {
        get {
            return av_player.isMuted
        }
        set {
            av_player.isMuted = newValue
        }
    }
    
    private var isPlayerItemObserversAdded = false
    
    public init(playerItem: IQPlayerItem,
         outputDelegate: IQPlaybackOutputDelegate?,
         isPlayerViewRequired: Bool = true) {
        av_player = AVPlayer(playerItem: playerItem.av_playerItem)
        if isPlayerViewRequired {
            av_playerLayer = AVPlayerLayer()
            av_playerLayer?.player = av_player
        } else {
            av_playerLayer = nil
        }
        self.outputDelegate = outputDelegate
        self.playerItem = playerItem
        super.init()
        addObserversToPlayer()
        addPlayerItemToPlayer()
    }
    
    private func addPlayerItemToPlayer() {
        if playerItem.isPlayerItemReady {
            self.replaceCurrentPlayerItem()
        } else {
            playerItem.playerItemReadyCompletion.append { [weak self] isSuccess in
                if isSuccess {
                    self?.replaceCurrentPlayerItem()
                } else {
                    self?.outputDelegate?.playback(playerItemFailedWithError: nil)
                }
            }
        }
    }
    
    private func replaceCurrentPlayerItem() {
        self.av_player.replaceCurrentItem(with: playerItem.av_playerItem)
        addObservers()
        if playerItem.isAutoPlayEnabled {
            play()
        }
    }
    
    public func getAVPlayerIfAvailable() -> AVPlayer? {
        return av_player
    }
    
    func replacePlayerItem(playerItem: IQPlayerItem) {
        self.stop()
        self.playerItem = playerItem
        addPlayerItemToPlayer()
    }
    
    //MARK: IQPlayerControlActionDelegate
    
    //Signals the desire to begin playback at the current item's natural rate.
    func play() {
        av_player.play()
    }
    
    //Pauses playback
    func pause() {
        av_player.pause()
    }
    
    func setMuted(enabled: Bool) {
        av_player.isMuted = enabled
    }
            
    func stop() {
        pause()
        av_player.currentItem?.asset.cancelLoading()
        av_player.replaceCurrentItem(with: nil)
        outputDelegate?.playbackStatusDidChange(newStatus: .stopped)
    }
    
    func seek(to time: TimeInterval, completion: @escaping (Bool) -> Void) {
        let myTime = CMTime(seconds: time, preferredTimescale: 60000)
        av_player.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero, completionHandler: completion)
    }
    
    func reset() {
        av_player.seek(to: CMTime.zero)
    }
    
    func seekForwardAndPlay(play: Bool) {
        let time = playerItem.seekForwardTimeInterval()
        let myTime = CMTime(seconds: time + currentTime, preferredTimescale: 60000)
        av_player.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    func seekBackwardAndPlay(play: Bool) {
        let time = playerItem.seekBackwardTimeInterval()
        let myTime = CMTime(seconds: currentTime - time, preferredTimescale: 60000)
        av_player.seek(to: myTime, toleranceBefore: .zero, toleranceAfter: .zero)
    }
    
    public func select(gravity: IQPlayerVideoGravity) {
        av_playerLayer?.videoGravity = gravity.avGravity
    }
    
    func removeObservers() {
        removeObserver(self, forKeyPath: #keyPath(av_player.status))
        removeObserver(self, forKeyPath: #keyPath(av_player.timeControlStatus))
        NotificationCenter.default.removeObserver(self)
        
        guard isPlayerItemObserversAdded == true else {
            return
        }
        
        removeObserver(self, forKeyPath: #keyPath(av_player.currentItem.status))
        removeObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackBufferEmpty))
        removeObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackBufferFull))
        removeObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackLikelyToKeepUp))
        removeObserver(self, forKeyPath: #keyPath(av_player.currentItem.loadedTimeRanges))
        av_player.replaceCurrentItem(with: nil)
    }
    
    deinit {
        removeObservers()
        print("IQVideoPlayer - IQPlayer Deallocated")
    }
}

extension IQPlayer {
    
    func addObserversToPlayer() {
        // Add observer for player status
        addObserver(self, forKeyPath: #keyPath(av_player.status), options: [.new, .initial], context: nil)
        
        addObserver(self, forKeyPath: #keyPath(av_player.timeControlStatus), options: [.new, .old], context: nil)
    }
    
    func addObservers() {
        
        av_player.addPeriodicTimeObserver(forInterval:
                                            CMTime(seconds: playerItem.options.playbackProgressInterval, preferredTimescale: 1000),
                                          queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let duration = self.playerItem.getDuration()
            self.outputDelegate?.playback(didProgressChangedTo: CMTimeGetSeconds(time),
                                  duration: TimeInterval(duration))
        }
        
        // Add observer for playerItem status
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.status), options: [.new, .initial], context: nil)
        
        // Add observer for playerItem buffer
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackBufferEmpty), options: .new, context: nil)
        
        // Add observer for monitoring buffer full event
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackBufferFull), options: .new, context: nil)
        
        // Add observer for monitoring whether the item will likely play through without stalling
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.isPlaybackLikelyToKeepUp), options: .new, context: nil)
        
        // Provides a collection of time ranges for which the player has the media data readily available
        addObserver(self, forKeyPath: #keyPath(av_player.currentItem.loadedTimeRanges), options: .new, context: nil)
        
        
        // Item has failed to play to its end time
        NotificationCenter.default.addObserver(self, selector: #selector(itemFailedToPlayToEndTime), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: av_player.currentItem)
        
        // Item has played to its end time
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidPlayToEndTime), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: av_player.currentItem)
        
        // Media did not arrive in time to continue playback
        NotificationCenter.default.addObserver(self, selector: #selector(itemPlaybackStalled), name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: av_player.currentItem)
        
        // A new access log entry has been added
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewAccessLogEntry), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: av_player.currentItem)
        
        // A new error log entry has been added
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewErrorLogEntry), name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object: av_player.currentItem)
        
        if #available(iOS 13.0, *) {
            // A media selection group changed its selected option
            NotificationCenter.default.addObserver(self, selector: #selector(mediaSelectionDidChange), name: AVPlayerItem.mediaSelectionDidChangeNotification, object: av_player.currentItem)
        }
        
        isPlayerItemObserversAdded = true
    }
    
    public override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(av_player.currentItem.status) {
            let status: AVPlayerItem.Status
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                outputDelegate?.playbackPlayerItemReadyToPlay()
            case .failed:
                outputDelegate?.playback(playerItemFailedWithError: av_player.currentItem?.error)
            case .unknown:
                outputDelegate?.playbackPlayerItemStatusChangedToUnknown()
            @unknown default:
                outputDelegate?.playbackPlayerItemStatusChangedToUnknown()
            }
        }
        
        if keyPath == #keyPath(av_player.currentItem.loadedTimeRanges) {
            if let rangeArray = change?[.newKey] as? [NSValue], let timeRange = rangeArray.first?.timeRangeValue {
                let duration = self.playerItem.getDuration()
                outputDelegate?.playback(didBufferChangedTo: CMTimeGetSeconds(timeRange.duration), duration: TimeInterval(duration))
            }
        }
        
        if keyPath == #keyPath(av_player.timeControlStatus) {
            var newStatus = AVPlayer.Status.unknown
            var oldStatus = AVPlayer.Status.unknown
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                newStatus = AVPlayer.Status(rawValue: statusNumber.intValue) ?? .unknown
            }
            
            if let statusNumber = change?[.oldKey] as? NSNumber {
                oldStatus = AVPlayer.Status(rawValue: statusNumber.intValue) ?? .unknown
            }
            
            if newStatus != oldStatus {
                if av_player.timeControlStatus == .playing || av_player.timeControlStatus == .paused {
                    outputDelegate?.playbackStartedPlaying()
                } else {
                    outputDelegate?.playbackStartedLoading()
                }
            }
            
            outputDelegate?.playbackStatusDidChange(newStatus: self.playbackStatus())
            
        }
        
        // Player Status
        if keyPath == #keyPath(av_player.status) {
            let status: AVPlayer.Status
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayer.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
                outputDelegate?.playbackPlayerReadyToPlay()
            case .failed:
                outputDelegate?.playback(playerFailedWithError: av_player.error)
            case .unknown:
                outputDelegate?.playbackPlayerStatusChangedToUnknown()
            @unknown default:
                outputDelegate?.playbackPlayerStatusChangedToUnknown()
            }
        }
        
        /*
         This property communicates a prediction of playability. Factors considered in this prediction
         include I/O throughput and media decode performance. It is possible for playbackLikelyToKeepUp to
         indicate NO while the property playbackBufferFull indicates YES. In this event the playback buffer has
         reached capacity but there isn't the statistical data to support a prediction that playback is likely to
         keep up. It is left to the application programmer to decide to continue media playback or not.
         */
        
        if keyPath == #keyPath(av_player.currentItem.isPlaybackBufferEmpty) {
            
            guard let currentItem = av_player.currentItem else {
                return
            }
            
            if currentItem.isPlaybackBufferEmpty {
                outputDelegate?.playbackBufferDidBecomeEmpty()
            } else {
                outputDelegate?.playbackBufferDidBecomeNonEmpty()
            }
        }
        
        /*
         This property reports that the data buffer used for playback has reach capacity.
         Despite the playback buffer reaching capacity there might not exist sufficient statistical
         data to support a playbackLikelyToKeepUp prediction of YES. See playbackLikelyToKeepUp above
         */
        if keyPath == #keyPath(av_player.currentItem.isPlaybackBufferFull) {
            
            guard let currentItem = av_player.currentItem else {
                return
            }
            
            if currentItem.isPlaybackBufferFull {
                outputDelegate?.playbackBufferDidBecomeFull()
            } else {
                outputDelegate?.playbackBufferDidBecomeNotFull()
            }
        }
        
        /*
         This property communicates a prediction of playability. Factors considered in this prediction
         include I/O throughput and media decode performance. It is possible for playbackLikelyToKeepUp to
         indicate NO while the property playbackBufferFull indicates YES. In this event the playback buffer has
         reached capacity but there isn't the statistical data to support a prediction that playback is likely to
         keep up. It is left to the application programmer to decide to continue media playback or not.
         See playbackBufferFull below.
         */
        if keyPath == #keyPath(av_player.currentItem.isPlaybackLikelyToKeepUp) {
            guard let currentItem = av_player.currentItem else {
                return
            }
            
            if currentItem.isPlaybackLikelyToKeepUp {
                outputDelegate?.playbackLikelyToKeepUp()
            }
        }
    }
    
    
    // Item has failed to play to its end time
    @objc func itemFailedToPlayToEndTime(_ notification: Notification) {
        let error:Error? = notification.userInfo!["AVPlayerItemFailedToPlayToEndTimeErrorKey"] as? Error
        outputDelegate?.playback(playerItemFailedWithError: error)
    }
    
    // Item has played to its end time
    @objc func itemDidPlayToEndTime(_ notification: Notification) {
        outputDelegate?.playbackDidEnd()
    }
    
    // Media did not arrive in time to continue playback
    @objc func itemPlaybackStalled(_ notification: Notification) {
        //isStalling = true
        // Used to calculate time delta of the stall which is printed to the Console
        //stallBeginTime = Date().toMillis()!
        outputDelegate?.playbackDidStalled()
    }
    
    // A new access log entry has been added
    @objc func itemNewAccessLogEntry(_ notification: Notification) {
        
        guard let playerItem = notification.object as? AVPlayerItem,
              let lastEvent = playerItem.accessLog()?.events.last else {
            return
        }
        
        outputDelegate?.playbackDidRecievePlayerItem(accessLog: IQPlayerItemAccessLog(event: lastEvent))
    }
    
    // A new error log entry has been added
    @objc func itemNewErrorLogEntry(_ notification: Notification) {
        
        guard let playerItem = notification.object as? AVPlayerItem,
              let lastEvent = playerItem.errorLog()?.events.last else {
            return
        }
        
        outputDelegate?.playbackDidRecievePlayerItem(errorLog: IQPlayerItemErrorLog(event: lastEvent))
    }
    
    // A media selection group changed its selected option
    @objc func mediaSelectionDidChange(_ notification: Notification) {
        outputDelegate?.playbackMediaSelectionDidChange()
    }
}
