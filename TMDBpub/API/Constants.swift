//
//  Constants.swift
//  TMDBpub
//
//  Created by Maksim Nosov on 10/08/2019.
//  Copyright © 2019 Maksim Nosov. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let baseURL = "https://api.themoviedb.org/3/"
    static var apiKey = "myApiKey"
    static var sessionId = "sessionId"
    static var accountId = "0"
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    static let upcoming = "movie/upcoming"
    static let topRatedMovies = "movie/top_rated"
    static let searchMovies = "search/movie"
    static let searchPerson = "search/person"
    static let popularMovies = "movie/popular"
    static let popularPersons = "person/popular"
    static let nowPlayingMovies = "movie/now_playing"
    static let infoAboutGenre = "genre/movie/list"
    static let discoverMovie = "discover/movie"
    static let imageYoutubeBaseURL = "https://i1.ytimg.com/vi/"
    static let gravatarImageURL = "https://www.gravatar.com/avatar/"
    static let movie = "movie"
    static let moviePosterPlaceholderImageName = "placeholder.png"
    static let language = "ru-RU"
    static let rating = "rating"
    
    // Application constants
    static let tintColor = #colorLiteral(red: 0.2304878831, green: 0.3483577371, blue: 0.5966511965, alpha: 1)
    
    // MARK: Authentication
    static let AuthenticationTokenNew = "authentication/token/new"
    static let AuthenticationSessionNew = "authentication/session/new"
    static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
    static let DeletingSessionId = "authentication/session"
    
    // MARK: Account
    static let Account = "account"
    static let UserID = "id"
    static let Person = "person"
    static let Images = "images"
    static let movie_credits = "/movie_credits"
    
    enum AccountLists: String {
        case AccountFavorites = "favorite/movies"
        case AccountWatchlist = "watchlist/movies"
        
        var description : String {
            switch self {
            case .AccountFavorites: return String(describing: "favorite/movies")
            case .AccountWatchlist: return String(describing: "watchlist/movies")
            }
        }
    }
    
    
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        static let MediaID = "media_id"
        static let MediaType = "media_type"
        static let Favorite = "favorite"
    }
    
    enum ParameterKeysAccount: String {
        case Favorite = "favorite"
        case Watchlist = "watchlist"
        
        var description : String {
            switch self {
            case .Favorite: return String(describing: "favorite")
            case .Watchlist: return String(describing: "watchlist")
            }
        }
    }
    
    enum MediaType: String {
        case Movie = "movie"
        case TV = "tv"
        
        var description : String {
            switch self {
            case .Movie: return String(describing: "movie")
            case .TV: return String(describing: "tv")
            }
        }
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
    }
    
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
    
    enum PersonImageSize: String {
        case w185_and_h278_bestv2
        case w300_and_h450_bestv2
        case w220_and_h330_face
    }
}
