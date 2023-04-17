//
//  API.swift
//  iTunes
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
	func request<T: Decodable>(route: ServiceConfiguration, result: @escaping (Result<T, ServiceError>) -> Void)
}

class APIService: ServiceProtocol {
	func request<T: Decodable>(route: ServiceConfiguration, result: @escaping (Result<T, ServiceError>) -> Void) {
		guard let url = URL(string: route.urlString) else {
			result(.failure(.invalidURL))
			return
		}
		
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = route.method.rawValue
        
        // Added to manipulate too many HTTP request error
        urlRequest.setValue("XYZ", forHTTPHeaderField: "User-Agent")
		
		let _ = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
			if let error = error {
				result(.failure(.networkError(error)))
				return
			}
			
			guard let httpResponse = response as? HTTPURLResponse else {
				result(.failure(.serverError(0)))
				return
			}
			
			guard let data = data else {
				result(.failure(.unableToParseData))
				return
			}

			do {
				let decoder = JSONDecoder()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let model = try decoder.decode(T.self, from: data)
				result(.success(model))
			} catch {
				result(.failure(.unableToParseData))
			}
		}.resume()
	}
}
