//
//  API.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 22.03.2023.
//

import Foundation


enum ServiceError: Error {
	case url
	case network
	case data
	case parse(description: String)
}

protocol ServiceProtocol {
	func request<T: Decodable>(route: ServiceConfiguration, result: @escaping (Result<T, ServiceError>) -> Void)
}

class APIService: ServiceProtocol {
	func request<T: Decodable>(route: ServiceConfiguration, result: @escaping (Result<T, ServiceError>) -> Void) {

		guard let url = URL.init(string: route.urlString) else {
			result(.failure(.url))
			return
		}

		let request = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if error != nil { result(.failure(.network))}

			guard let data = data else {
				result(.failure(.data))
				return
			}

			do {
				let model = try JSONDecoder().decode(T.self, from: data)
				result(.success(model))
				
			} catch { error
				let err = error as NSError
				result(.failure(.parse(description: err.description)))
			}

		}.resume()
	}
}
