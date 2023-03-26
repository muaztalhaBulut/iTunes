//
//  API.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 22.03.2023.
//

import Foundation


//
//  API.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 22.03.2023.
//

import Foundation

enum ServiceError: Error {
	case invalidURL
	case unableToParseData
	case networkError(Error)
	case serverError(Int)
}

protocol ServiceProtocol {
	func request<T: Decodable>(route: APIRouter, result: @escaping (Result<T, ServiceError>) -> Void)
}

class APIService: ServiceProtocol {
	func request<T: Decodable>(route: APIRouter, result: @escaping (Result<T, ServiceError>) -> Void) {

		guard let url = URL.init(string: route.urlString) else {
			result(.failure(.invalidURL))
			return
		}

		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let error = error {
				result(.failure(.networkError(error)))
				return
			}
			guard let data = data else {
				result(.failure(.unableToParseData))
				return
			}

			do {
				let model = try JSONDecoder().decode(T.self, from: data)
				result(.success(model))
				
			} catch {
				result(.failure(.unableToParseData))
			}

		}
		task.resume()
	}
}
