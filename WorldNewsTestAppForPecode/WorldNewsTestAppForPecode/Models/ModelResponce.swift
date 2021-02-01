//
//  ModelResponce.swift
//  WorldNewsTestAppForPecode
//
//  Created by Anton on 30.01.2021.
//

import Foundation

struct Responce: Codable {
    let status: String?
    let totalResult: Int?
    let articles: [Article]
}

struct Article: Codable {
    let source: SourceName
    let title: String
    let description: String?
    let author: String?
    let urlToImage: String?
    let publishedAt: String?
    let url: String?
}

struct SourceName: Codable {
    let name: String
}

struct ArticleViewModel {
    let source: String
    let title: String
    let description: String?
    let author: String?
    let urlToImage: URL?
    let url: String?
}
