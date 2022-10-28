//
//  RecommendationMovie.swift
//  Movie
//
//  Created by Алена Панченко on 28.10.2022.
//

import Foundation

/// Модель массива рекоммендации
struct RecommendationMovieResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }

    let movies: [RecommendationMovie]
}
