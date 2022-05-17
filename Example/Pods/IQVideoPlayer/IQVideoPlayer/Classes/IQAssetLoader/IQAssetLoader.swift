//
//  IQAssetLoader.swift
//  IQPlayerSDK
//
//  Created by Nitin Chadha on 03/04/22.
//

import Foundation
import AVFoundation

public protocol IQAssetLoaderDelegate {
    
    //IQAssetLoader will request certificate for DRM content, if certificate is already persisted then it can be passed by value in protperty certificateData of IQAssetLoader
    
    
    func assetLoaderRequest(forCertificate response: @escaping (Data?) -> Void)
    
    func assetLoaderRequest(forCKC spc:Data, response: @escaping (Data?) -> Void)
}

protocol IQAsserLoaderOutput {
    
    func assetLoaderRequestInitiated() 
    
}

class IQAssetLoader: NSObject {
    
    
    var outputDelegate: IQAsserLoaderOutput?
    
    let queue = DispatchQueue(label: "fairplay.refresher.queue")
    
    var certificateData: Data?
    var delegate: IQAssetLoaderDelegate?
    
    init(asset: AVURLAsset, delegate: IQAssetLoaderDelegate? = nil) {
        super.init()
        self.delegate = delegate
        asset.resourceLoader.setDelegate(self, queue: queue)
    }
}

extension IQAssetLoader: AVAssetResourceLoaderDelegate {
    
    func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        delegate?.assetLoaderRequest(forCertificate: { [weak self] (certificate) in
            if let certificate = certificate, let spc = self?.createSPCForApplicationCertificate(certificate: certificate, loadingRequest: loadingRequest) {
                self?.delegate?.assetLoaderRequest(forCKC: spc, response: { data in
                    guard let data = data else { return }
                    loadingRequest.dataRequest?.respond(with: data)
                    loadingRequest.finishLoading()
                })
                
            }
        })
        return true
    }
    
    func createSPCForApplicationCertificate(certificate: Data, loadingRequest: AVAssetResourceLoadingRequest) -> Data? {
        guard let assetIDString = loadingRequest.request.url?.host else {
            return nil
        }
        
        guard let assetIDdata = assetIDString.data(using: .utf8) else { return nil }
        do {
            let spc = try loadingRequest.streamingContentKeyRequestData(forApp: certificate, contentIdentifier: assetIDdata, options: nil)
            return spc
        } catch {
            print("Error while creating SPC")
        }
        return nil
    }
}
