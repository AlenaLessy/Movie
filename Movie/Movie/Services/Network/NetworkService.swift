//
//  NetworkService.swift
//  Movie
//
//  Created by Алена Панченко on 25.10.2022.
//

import Foundation

/// sdf
enum NetworkError: Error {
    case unknown
    case decodingFailure
    case urlFailure
}

final class NetworkService {
    private init() {}

    static let shared = NetworkService()

    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    // мой ключ при регистрации
    private let apiKey = "0ec73b9e206615099e204ec4a0da2380"
    // базовый адрес
    private let baseUrlString = "https://api.themoviedb.org/3/"
    // куда мы идем и что мы отдаем серверу
    func requestMovies(completion: ((Result<[Movie], NetworkError>) -> ())?) {
        guard var url = URL(string: baseUrlString + "movie/popular") else {
            completion?(.failure(.urlFailure))
            return
        }

        url.append(queryItems: [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "ru-RU")
        ])

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        session.dataTask(with: request) { [weak self] data, _, _ in
            guard let self else { return }
            if let data {
                guard let movieResponse = try? self.decoder.decode(MovieResponse.self, from: data) else {
                    completion?(.failure(.decodingFailure))
                    return
                }
                completion?(.success(movieResponse.movies))
            } else {
                completion?(.failure(.unknown))
            }
        }.resume()
    }

    func requestMovie(id: Int, completion: ((Result<MovieDetails, NetworkError>) -> ())?) {
        guard var url = URL(string: baseUrlString + "movie/\(id)") else {
            completion?(.failure(.urlFailure))
            return
        }

        url.append(queryItems: [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "ru-RU")
        ])

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // пока всегда такая будет формат ответа
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        session.dataTask(with: request) { [weak self] data, _, _ in
            guard let self else { return }
            // если не пришла дата
            guard let data else {
                completion?(.failure(.unknown))
                return
            }
            guard let detail = try? self.decoder.decode(MovieDetails.self, from: data) else {
                completion?(.failure(.decodingFailure))
                return
            }
            completion?(.success(detail))
        }.resume()
    }
}

///
struct MovieResponse: Decodable {
    let movies: [Movie]

    enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

/// Модель фильма
struct Movie: Decodable {
    let id: Int
    let posterPath: String?
    let overview: String
    let releaseDate: String
    let title: String
    let rating: Double

    enum CodingKeys: String, CodingKey {
        case id
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
        case title
        case rating = "vote_average"
    }
}

/// Модель деталей фильма
struct MovieDetails: Decodable {
    let posterPath: String
    let overview: String
    let title: String
    let rating: Double
    let tagline: String

    enum CodingKeys: String, CodingKey {
        case posterPath = "backdrop_path"
        case overview
        case title
        case rating = "vote_average"
        case tagline
    }
}
