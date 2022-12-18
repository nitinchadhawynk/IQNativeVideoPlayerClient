//
//  Metadata.swift
//  IQNativeVideoPlayerClient
//
//  Created by B0223972 on 18/05/22.
//

import Foundation

public struct Metadata {
    
    public init(title: String, subtitle: String, image: Data? = nil, description: String, rating: String, genre: String) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.description = description
        self.rating = rating
        self.genre = genre
    }
    
    var title: String
    var subtitle: String
    var image: Data?
    var description: String
    var rating: String
    var genre: String
}
