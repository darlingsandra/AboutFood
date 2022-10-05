//
//  Article.swift
//  AboutFood
//
//  Created by Александра Широкова on 03.10.2022.
//

import Foundation

struct Article: Decodable, Hashable {
    let id: String
    let title: String
    let image: ImageArticle
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ImageArticle: Decodable {
    let one: String
    let two: String
    let three: String
    
    enum CodingKeys: String, CodingKey {
        case one = "1x"
        case two = "2x"
        case three = "3x"
    }
}
