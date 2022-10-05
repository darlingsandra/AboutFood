//
//  ConfiguringViewProtocol.swift
//  AboutFood
//
//  Created by Александра Широкова on 05.10.2022.
//

import Foundation

protocol ConfiguringCellProtocol {
    static var identifier: String { get }
    func configure(with date: Article)
}
