//
//  IQPlayerView.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import UIKit
import CoreMedia

public class IQPlayerView: UIView {
    
    public private(set) var playerItem: IQPlayerItem
    
    var player: IQPlayer!
    
    private var output: IQPlaybackOutputManager!
    
    private var loader: AcitivityIndicatorView?
    
    public init(frame: CGRect, playerItem: IQPlayerItem) {
        self.playerItem = playerItem
        super.init(frame: frame)
        output = IQPlaybackOutputManager(playerView: self)
        self.player = IQPlayer(playerItem: playerItem, outputDelegate: output)
        configurePlayerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        player.layer?.frame = bounds
    }
    
    private func configurePlayerView() {
        self.playerItem.outputManager = output
        addPlayerLayer()
        addListenerIfDefaultPlaybackLoaderEnabled()
    }
    
    private func addPlayerLayer() {
        guard let playerLayer = player.layer else { return }
        layer.addSublayer(playerLayer)
    }
    
    public func layer() -> CALayer? {
        return player.layer
    }
    
    /**
     * replacePlayerItem can be called to inject a new player item with different playback options.
     *
     * @params IQPlayerItem new playback player item
     */
    public func replacePlayerItem(with item: IQPlayerItem) {
        self.player.replacePlayerItem(playerItem: item)
        self.playerItem = item
        self.playerItem.outputManager = output
        if playerItem.isAutoPlayEnabled {
            player.play()
        }
    }
    
    /**
     * Adds the specified IQPlayerView output object to the receiver.
     *
     * @param player view output object to associate with the item.
     */
    public func add(output: IQPlayerViewOutput) {
        self.output.append(listener: output)
    }
    
    /**
     * Removes the specified IQPlayerView output object from the receiver.
     *
     * @param The player view output object to remove.
     */
    public func remove(output: IQPlayerViewOutput) {
        self.output.remove(listener: output)
    }
    
    deinit {
        print("IQVideoPlayer - IQPlayerView Deallocated")
    }
}

extension IQPlayerView {
    
    public var currentTime: Double {
        return player.currentTime.isNaN ? 0 : player.currentTime
    }
    
    public func play() {
        player.play()
    }
    
    public func pause() {
        player.pause()
    }
    
    public func seek(to time: TimeInterval, completion: @escaping (Bool) -> Void = { _ in }) {
        player.seek(to: time, completion: completion)
    }
    
    
    public func seekToLive(completion: @escaping ((Bool) -> Void) = { _ in }) {
        if let liveDuration = playerItem.liveDuration() {
            seek(to: liveDuration, completion: completion)
        }
    }
    
    public func reset() {
        player.reset()
    }
    
    public func stop() {
        player.stop()
    }
    
    public func duration() -> TimeInterval {
        return TimeInterval(playerItem.getDuration())
    }
    
    public var isMuted: Bool {
        get { return player.isMuted }
        set { player.isMuted = newValue }
    }
    
    public func moveForward() {
        player.seekForwardAndPlay(play: true)
    }
    
    public func moveBackward() {
        player.seekBackwardAndPlay(play: true)
    }
    
    public func select(gravity: IQPlayerVideoGravity) {
        player.select(gravity: gravity)
    }
    
    public func playbackStatus() -> IQPlaybackStatus {
        player.playbackStatus()
    }
}

extension IQPlayerView: IQPlayerViewOutput {
    
    private func addListenerIfDefaultPlaybackLoaderEnabled() {
        guard playerItem.options.isPlayerLoaderEnabled else { return }
        output.append(listener: self)
    }
    
    public func playback(playerView: IQPlayerView, didReceivePlaybackLifeCycleEvent event: IQPlayerLifeCycleEvent) {
        
        guard playerItem.options.isPlayerLoaderEnabled else { return }
        
        switch event {
        case .playerItemNotLoading:
            hideLoader()
            
        case .playerItemloading:
            showLoader()
            
        default:
            break
        }
    }
    
    func showLoader() {
        if loader == nil {
            self.loader = AcitivityIndicatorView(view: self)
        }
        loader?.show()
    }
    
    func hideLoader() {
        loader?.hide()
    }
}
