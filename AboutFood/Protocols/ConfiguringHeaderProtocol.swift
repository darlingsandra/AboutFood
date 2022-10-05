//
//  ConfiguringHeaderProtocol.swift
//  AboutFood
//
//  Created by Александра Широкова on 05.10.2022.
//

import Foundation

protocol ConfiguringHeaderProtocol {
    static var identifier: String { get }
    func configure(with date: ArticleSection)
}
