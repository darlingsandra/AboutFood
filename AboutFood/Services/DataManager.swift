//
//  DataManager.swift
//  AboutFood
//
//  Created by Александра Широкова on 03.10.2022.
//

import Foundation

enum ErrorLoad: Error {
    case invalidURL
    case noData
    case decodingError
}

enum API: String {
    case articlesURL = "jsonviewer"
}

final class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func fetch<T: Decodable>(dataType: T.Type, url: String, complition: @escaping (Result<T, ErrorLoad>) -> Void) {
        guard let fileLocation = Bundle.main.url(forResource: url, withExtension: "json") else {
            complition(.failure(.invalidURL))
            return
        }
        
        guard let data = try? Data(contentsOf: fileLocation) else {
            complition(.failure(.noData))
            return
        }
                
        do {
            let decoder = JSONDecoder()
            let sections = try decoder.decode(T.self, from: data)
            complition(.success(sections))
        } catch let error {
            complition(.failure(.noData))
            print(error)
        }
    }
    
    func fetchImage(url: String, completion: @escaping (Result<Data, ErrorLoad>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.invalidURL))
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            completion(.success(data))
        } catch {
            completion(.failure(.noData))
        }
    }
}
