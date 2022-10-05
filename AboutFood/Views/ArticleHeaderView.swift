//
//  ArticleHeaderView.swift
//  AboutFood
//
//  Created by Александра Широкова on 04.10.2022.
//

import UIKit

final class ArticleHeaderView: UICollectionReusableView {
    
    // MARK: - Properties
    private var section: ArticleSection?
    private let spasing: CGFloat = 10.0
    private let titleLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
}

// MARK: - ConfiguringHeaderProtocol
extension ArticleHeaderView: ConfiguringHeaderProtocol {
    
    static let identifier = String(describing: ArticleHeaderView.self)
    
    func configure(with section: ArticleSection) {
        self.section = section
        titleLabel.text = section.header
    }
    
}

// MARK: - Private methods
private extension ArticleHeaderView {
    
    func setupView() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = UIColor.darkBlue
        addSubview(titleLabel)
      
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spasing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spasing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: spasing),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spasing)
        ])
    }
    
}
