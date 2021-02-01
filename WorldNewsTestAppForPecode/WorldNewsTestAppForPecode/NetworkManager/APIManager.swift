//
//  APIManager.swift
//  WorldNewsTestAppForPecode
//
//  Created by Anton on 30.01.2021.
//

import Foundation

class APIManager {
    
    let networking = Networking()
    let apiKey = "49a560b93f7c4d2387d9756bd9dfc93c"
    
    func articles(completion: @escaping ([Article]) -> Void) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=ua&apiKey="+apiKey
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let request = URLRequest(url: url)
        loadArticles(request: request, completion: completion)
    }
    
    func search(word: String, completion: @escaping ([Article]) -> Void) {
        let urlString = "https://newsapi.org/v2/everything?q=\(word)&apiKey="+apiKey
        
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let request = URLRequest(url: url)
        loadArticles(request: request, completion: completion)
    }
    
    // MARK: Private methods
    
    private func loadArticles(pagination: Bool = false, request: URLRequest, completion: @escaping ([Article]) -> Void) {
        networking.perform(request: request) { (data) in
            guard let res = data else {
                completion([])
                return
            }
            
            let response = try? JSONDecoder().decode(Responce.self, from: res)
            let articles = response?.articles ?? []
            
            completion(articles)
        }
    }
    
}
