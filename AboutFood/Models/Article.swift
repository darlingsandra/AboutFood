//
//  Article.swift
//  AboutFood
//
//  Created by Александра Широкова on 03.10.2022.
//

import Foundation

struct SectionList: Decodable {
    let sections: [Section]
}

struct Section: Decodable {
    let id: String
    let header: String
    let items: [Article]
}

struct Article: Decodable {
    let id: String
    let title: String
    let image: ImageArticle
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
