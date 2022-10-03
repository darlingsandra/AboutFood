//
//  ViewController.swift
//  AboutFood
//
//  Created by Александра Широкова on 03.10.2022.
//

import UIKit

class ArticlesViewController: UICollectionViewController {

    var sections: [Section] = []
    
    private lazy var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showSpinner()
        loadArticles()
    }
}

private extension ArticlesViewController {
    func setupView() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
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
                self.sections = sectionList.sections
                self.hideSpinner()
            case .failure(_):
                self.hideSpinner()
            }
        }
    }
}

