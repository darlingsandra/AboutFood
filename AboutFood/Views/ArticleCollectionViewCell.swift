//
//  ArticleCollectionViewCell.swift
//  AboutFood
//
//  Created by Александра Широкова on 03.10.2022.
//

import UIKit

final class ArticleCollectionViewCell: UICollectionViewCell {
      
    // MARK: - Properties
    private var article: Article?
    private let spasing: CGFloat = 10.0
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
     }

     required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
}

// MARK: - ConfiguringCellProtocol
extension ArticleCollectionViewCell: ConfiguringCellProtocol {
    
    static let identifier: String = String(describing: ArticleCollectionViewCell.self)
    
    func configure(with article: Article) {
        self.article = article

        titleLabel.text = article.title
        loadImage(url: getUrlImage(with: article))
    }
}

// MARK: - Private methods
private extension ArticleCollectionViewCell {
    
    func setupView() {
        layer.cornerRadius = 20
        clipsToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.frame = titleLabel.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        imageView.addSubview(blurEffectView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.darkBlue
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        imageView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -spasing),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: spasing),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -spasing),
            
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurEffectView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -spasing),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurEffectView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }
    
    func getUrlImage(with article: Article) -> String {
        let px = UIScreen.main.scale
        switch px {
        case 1.0: return article.image.one
        case 2.0: return article.image.two
        case 3.0: return article.image.three
        default: return article.image.one
        }
    }
    
    func loadImage(url: String) {
        DispatchQueue.global().async {
            DataManager.shared.fetchImage(url: url) { result in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(data: data)
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self.imageView.image = UIImage(named: "Default")
                    }
                }
            }
        }
    }
}


