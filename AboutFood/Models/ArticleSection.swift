//
//  ArticleCollection.swift
//  AboutFood
//
//  Created by Александра Широкова on 04.10.2022.
//

import Foundation

struct SectionList: Decodable {
    let sections: [ArticleSection]
}

struct ArticleSection: Decodable, Hashable {
    let id: String
    let header: String
    let items: [Article]
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
    
    static func == (lhs: ArticleSection, rhs: ArticleSection) -> Bool {
        return lhs.id == rhs.id
    }
}
