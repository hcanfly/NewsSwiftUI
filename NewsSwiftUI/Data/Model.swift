//
//  Model.swift
//  News-SwiftUI
//
//  Created by Gary Hanson on 6/12/21.
//

import Foundation


enum HeadlineCategory: String {
    case top = "News"
    case tech = "Tech"
    case entertainment = "Entertainment"
    case sports = "Sports"
    case science = "Science"
    case health = "Health"
    case business = "Business"
}

struct StorySource: Decodable {
    let id: String?
    let name: String?
}

struct NewsStory: Decodable {
    let author: String?
    let title: String?
    let url: String?
    let description: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let source: StorySource
}

struct NewsStories : Decodable {
    let stories: [NewsStory]

    enum CodingKeys: String, CodingKey {
        case articles
    }
}

extension NewsStories  {

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        let input = try? values.decode([NewsStory].self, forKey: .articles)
        
        if input == nil {
            stories = [NewsStory]()
        } else {
            stories = input!
        }
    }

    init() {
        stories = [NewsStory]()
    }
}

