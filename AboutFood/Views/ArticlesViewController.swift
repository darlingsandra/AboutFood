//
//  ViewController.swift
//  AboutFood
//
//  Created by Александра Широкова on 03.10.2022.
//

import UIKit

final class ArticlesViewController: UIViewController {
    
    // MARK: - Properties
    var articleSections: [ArticleSection] = []
    
    var dataSource: UICollectionViewDiffableDataSource<ArticleSection, Article>!
    var collectionView: UICollectionView!
      
    private let coutSelectedArticle = 6
    private lazy var activityIndicator = UIActivityIndicatorView()
    private lazy var errorView: UIStackView  = {
        let errorLabel =  UILabel()
        errorLabel.font = UIFont.systemFont(ofSize: 18)
        errorLabel.textColor = .gray
        errorLabel.text = "Что то пошло не так..."
        errorLabel.textAlignment = .center
        let errorView = UIStackView(arrangedSubviews: [errorLabel])
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.isHidden = true
        return errorView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        
        showSpinner()
        loadArticles()
        setupView()
    }
}

// MARK: - UICollectionViewDelegate
extension ArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let selectedItems = collectionView.indexPathsForSelectedItems {
            if selectedItems.contains(indexPath) {
                collectionView.deselectItem(at: indexPath, animated: true)
                return false
            } else if selectedItems.count >= coutSelectedArticle { return false }
        }
        return true
    }
}

// MARK: - CollectionView
extension ArticlesViewController {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createViewLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        registerCell()
        setupDataSourse()
        reloadData()
    }
    
    func registerCell() {
        collectionView.register(ArticleCollectionViewCell.self, forCellWithReuseIdentifier: ArticleCollectionViewCell.identifier)
    
        collectionView.register(
            ArticleHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ArticleHeaderView.identifier)
    }
    
    func createViewLayout() -> UICollectionViewCompositionalLayout {
        let spasing = CGFloat(10.0)
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: spasing,
            leading: spasing,
            bottom: spasing,
            trailing: spasing)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.95),
            heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: spasing, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = spasing
        layout.configuration = config
                
        return layout
    }
}

// MARK: - DiffableDataSource
extension ArticlesViewController {
    
    typealias ArticleDataSource = UICollectionViewDiffableDataSource<ArticleSection, Article>
    
    private func setupDataSourse() {
        dataSource = ArticleDataSource(collectionView: collectionView) { (collectionView, indexPath, data) in
            self.configure(ArticleCollectionViewCell.self, with: data, for: indexPath)
        }
              
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let self = self else { return nil }
            return self.configure(ArticleHeaderView.self, with: self.articleSections[indexPath.row], for: indexPath)
        }
    }
    
    func configure<T: ConfiguringCellProtocol>(_ type: T.Type, with data: Article, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError("Error \(type)")
        }
        cell.configure(with: data)
        return cell
    }
    
    func configure<T: ConfiguringHeaderProtocol>(_ type: T.Type, with data: ArticleSection, for indexPath: IndexPath) -> T {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: type.identifier, for: indexPath) as? T else {
            fatalError("Error \(type)")
        }
        header.configure(with: data)
        return header
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<ArticleSection, Article>()
        articleSections.forEach { section in
            snapshot.appendSections([section])
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

// MARK: - Private methods
private extension ArticlesViewController {
    func setupView() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
          
        setupCollectionView()
        
        view.addSubview(errorView)
        NSLayoutConstraint.activate([
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            
        ])
    }
    
    func showSpinner() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideSpinner() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
        
    func loadArticles() {
        DataManager.shared.fetch(dataType: SectionList.self, url: API.articlesURL.rawValue) { result in
            switch result {
            case .success(let sectionList):
                self.articleSections = sectionList.sections
                self.hideSpinner()
                self.errorView.isHidden = true
            case .failure(_):
                self.hideSpinner()
                self.errorView.isHidden = false
            }
        }
    }
}
