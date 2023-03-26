//
//  APIRouter.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 23.03.2023.
//

import Foundation
//https://itunes.apple.com/search?term=""&media=all&limit=20&offset=0
//https://itunes.apple.com/search?term=""&media=all&limit=20&offset=0


enum APIRouter: ServiceConfiguration {
	case search(term: String?, media: MediaType, limit: Int, offset: Int)
	case movie(term: String?, media: MediaType, limit: Int, offset: Int)
	case music(term: String?, media: MediaType, limit: Int, offset: Int)
	case app(term: String?, media: MediaType, limit: Int, offset: Int)
	case book(term: String?, media: MediaType, limit: Int, offset: Int)
	
	private static let baseURL = "https://itunes.apple.com"
	
	private var endPoint: String {
		switch self {
		case .search: return "/search?"
		case .movie: return "/search?term=movie"
		case .music: return "/search?term=music"
		case .app: return "/search?term=app"
		case .book: return "/search?term=book"
		}
	}
	
	private var parameters: [(String, String)] {
		var params: [(String, String)] = []
		switch self {
		case .search(let term, let media, let limit, let offset):
			params.append(("term", term ?? ""))
			params.append(("media", media.value))
			params.append(("limit", "\(limit)"))
			params.append(("offset", "\(offset)"))
		case .movie(let term, let media, let limit, let offset),
			 .music(let term, let media, let limit, let offset),
			 .app(let term, let media, let limit, let offset),
			 .book(let term, let media, let limit, let offset):
			params.append(("term", term ?? ""))
			params.append(("media", media.value))
			params.append(("limit", "\(limit)"))
			params.append(("offset", "\(offset)"))
		}
		return params
	}
	
	var urlString: String {
		let paramString = parameters.map { "\($0.0)=\($0.1)" }.joined(separator: "&")
		print(APIRouter.baseURL + endPoint + paramString)
		return APIRouter.baseURL + endPoint + paramString
	}
}

