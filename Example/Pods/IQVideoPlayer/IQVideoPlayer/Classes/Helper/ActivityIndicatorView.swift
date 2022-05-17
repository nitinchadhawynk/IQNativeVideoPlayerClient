//
//  ActivityIndicatorView.swift
//  IQVideoPlayer
//
//  Created by Nitin Chadha on 12/04/22.
//

import UIKit

class AcitivityIndicatorView {
    
    var indicator: UIActivityIndicatorView
    
    init(view: UIView) {
        #if os(iOS)
        var indicator = UIActivityIndicatorView(style: .gray)
        #elseif os(tvOS)
        var indicator = UIActivityIndicatorView(style: .medium)
        #endif
        
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .medium)
        }
        indicator.color = .gray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        
        view.addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        self.indicator = indicator
    }
    
    func show() {
        indicator.startAnimating()
    }
    
    func hide() {
        indicator.stopAnimating()
    }
}
