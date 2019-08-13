//
//  Constants.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation

struct Constants {
    
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "894ef0c8f1e1986a8da271985a21d48b"
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    static let upcoming = "movie/upcoming"
    static let topRatedMovies = "movie/top_rated"
    static let searchMovies = "search/movie"
    static let popularMovies = "movie/popular"
    static let infoAboutGenre = "genre/movie/list"
    static let discoverMovie = "discover/movie"
    static let moviePosterPlaceholderImageName = "placeholder.png"
    static let language = "ru-RU"
    
    struct ResponseKey {
        static let id = "id"
        static let title = "title"
        static let releaseDate = "release_date"
        static let vote = "vote_average"
        static let adult = "adult"
        static let language = "original_language"
        static let results = "results"
        static let voteCount = "vote_count"
        static let tagline = "tagline"
        static let revenue = "revenue"
        static let budget = "budget"
        static let posterPath = "poster_path"
        static let page = "page"
        static let totalPages = "total_pages"
    }
    
    static func fetchPosterUrl(withPosterPath posterPath: String, posterSize: String) -> String {
        let resourcePath = posterSize + "/" + posterPath
        return (Constants.imageBaseURL + resourcePath)
    }
    
    static func fetchBackdropUrl(withBackdropPath backdropPath: String, backdropSize: String) -> String {
        let resourcePath = backdropSize + "/" + backdropPath
        return (Constants.imageBaseURL + resourcePath)
    }
    
    enum PosterSize: String {
        case w92
        case w154
        case w185
        case w342
        case w500
        case w780
    }
    
    enum BackdropSize: String {
        case w300
        case w780
        case w1280
    }
}
