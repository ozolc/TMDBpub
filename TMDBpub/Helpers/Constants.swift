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
    static let getMoviesURLResourcePath = "search/movie?api_key=%@&query=titanic&language=en-US"
    static let allMoviesURLResourcePath = "discover/movie?language=en-US&api_key=%@&sort_by=%@&page=%d"
    static let movieDetailsURLResourcePath = "movie/%d?api_key=%@&language=en-US"
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
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
}
