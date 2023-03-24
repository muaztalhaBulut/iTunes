//
//  RequestModel.swift
//  iTunes
//
//  Created by Talha on 22.03.2023.
//

// MARK: - SearchResponseModel
struct SearchResponseModel: Codable {
	let resultCount: Int?
	let results: [MediaItem]?
}

// MARK: - MediaItem
struct MediaItem: Codable {
	let wrapperType: String?
	let kind: String?
	let collectionName: String?
	let artworkUrl100: String?
	let collectionPrice: Double?
	let trackPrice: Double?
	let releaseDate: String?
	let currency: String?
	let country: String?
	let trackId: Int?
	let longDescription: String?
}
