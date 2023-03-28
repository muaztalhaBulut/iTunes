//
//  DetailViewModel.swift
//  iTunes
//
//  Created by Talha on 28.03.2023.
//

import UIKit
import Kingfisher

protocol DetailViewModelProtocol {
	var mediaItem: MediaItem { get }
	var releaseDate: String { get }
	var artworkUrl100: String { get }
	var country: String { get }
	var collectionName: String { get }
}

final class DetailViewModel: DetailViewModelProtocol {
	
	private(set) var mediaItem: MediaItem
	
	init(mediaItem: MediaItem) {
		self.mediaItem = mediaItem
	}
	var releaseDate: String {
		let dateString = mediaItem.releaseDate?.formattedString() ?? ""
		return dateString
	}
	
	var artworkUrl100: String {
		return mediaItem.artworkUrl100 ?? ""
	}
	
	var country: String {
		return mediaItem.country ?? ""
	}
	
	var collectionName: String {
		return mediaItem.collectionName ?? ""
	}
}

