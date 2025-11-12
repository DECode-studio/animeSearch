//
//  Anime.swift
//  animeSearch
//
//  Created by user on 12/11/25.
//

import Foundation

struct Anime: Identifiable, Decodable {
    let id: Int
    let title: String
    let synopsis: String?
    let imageUrl: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case title
        case synopsis
        case images
    }
    
    enum ImagesKeys: String, CodingKey {
        case jpg
    }
    
    enum JPGKeys: String, CodingKey {
        case image_url
    }
    
    init(
        from decoder: Decoder
    ) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        synopsis = try? container.decode(String.self, forKey: .synopsis)
        
        if let images = try? container.nestedContainer(keyedBy: ImagesKeys.self, forKey: .images),
           let jpg = try? images.nestedContainer(keyedBy: JPGKeys.self, forKey: .jpg),
           let urlString = try? jpg.decode(String.self, forKey: .image_url) {
            imageUrl = URL(string: urlString)
        } else {
            imageUrl = nil
        }
    }
}
