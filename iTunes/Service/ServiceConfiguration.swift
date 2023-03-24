//
//  Constant.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 22.03.2023.

internal protocol ServiceConfiguration {
	var urlString: String {get}
}

enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
}

