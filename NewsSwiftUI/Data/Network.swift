//
//  Network.swift
//  News-SwiftUI
//
//  Created by Gary Hanson on 6/12/21.
//

import Foundation


let newsapiAPIKey = "65bbe17046734447a60a328d439aa0ac"     // "<your newsapi API key goes here>"

let topHeadlinesRequestURLString = "https://newsapi.org/v2/top-headlines?country=us&apiKey=\(newsapiAPIKey)"
let techHeadlinesRequestURLString = "https://newsapi.org/v2/top-headlines?category=technology&country=us&apiKey=\(newsapiAPIKey)"
let entertainmentHeadlinesRequestURLString = "https://newsapi.org/v2/top-headlines?category=entertainment&country=us&apiKey=\(newsapiAPIKey)"
let sportsHeadlinesRequestURLString = "https://newsapi.org/v2/top-headlines?category=sports&country=us&apiKey=\(newsapiAPIKey)"
let scienceHeadlinesRequestURLString = "https://newsapi.org/v2/top-headlines?category=science&country=us&apiKey=\(newsapiAPIKey)"
let healthHeadlinesRequestURLString = "https://newsapi.org/v2/top-headlines?category=health&country=us&apiKey=\(newsapiAPIKey)"
let businessHeadlinesRequestURLString = "https://newsapi.org/v2/top-headlines?category=business&country=us&apiKey=\(newsapiAPIKey)"


// sources: associated-press, bbc-news, Bloomberg, politico, reuters, the-hill, the-wall-street-journal, wired
// tech sources: ars-technica, engadget, new-scientist, recode, techcrunch
// sports sources: bleacher-report, espn


enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case invalidImageData
    case invalidImageForThumbnail
}

enum NetworkData {

    static func headlineURL(forCategory category: HeadlineCategory) -> URL? {
        var urlString = ""

        switch category {
        case .top:
            urlString = topHeadlinesRequestURLString
        case .tech:
            urlString = techHeadlinesRequestURLString
        case .entertainment:
            urlString = entertainmentHeadlinesRequestURLString
        case .sports:
            urlString = sportsHeadlinesRequestURLString
        case .science:
            urlString = scienceHeadlinesRequestURLString
        case .health:
            urlString = healthHeadlinesRequestURLString
        case .business:
            urlString = businessHeadlinesRequestURLString
       }

        return URL(string: urlString)
    }
    
    static func fetch<T: Decodable>(category: HeadlineCategory, myType: T.Type) async throws -> T {
        guard let url = headlineURL(forCategory: category) else {
            print("Invalid URL. Did you enter your newsapi api key in Network.swift?")
            throw NetworkError.invalidURL
          }
        
        let session = URLSession.shared

        let (data, response) = try await session.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw NetworkError.invalidServerResponse
        }
        
        let decoder = JSONDecoder()
        //print(String(bytes: data, encoding: String.Encoding.utf8))
        let theNews = try decoder.decode(T.self, from: data)

        return theNews
    }
}
