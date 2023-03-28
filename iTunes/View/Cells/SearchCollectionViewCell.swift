//
//  SearchCollectionViewCell.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 24.03.2023.
//

import UIKit
import Kingfisher

final class SearchCollectionViewCell: UICollectionViewCell {
	private lazy var randomImage: String = "https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM749/en_US/itunes-macos-icon-240.png"
	
	private lazy var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.backgroundColor = .gray
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()
	enum Identifier: String {
		case custom = "search"
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .lightGray
		
		contentView.addSubview(imageView)
		imageView.setConstaints(
			top: contentView.topAnchor,
			leading: contentView.leadingAnchor,
			bottom: contentView.bottomAnchor,
			trailing: contentView.trailingAnchor,
			topConstraint: 15,
			leadingConstraint: 15,
			bottomConstraint: 15,
			trailingConstraint: 15)
	}
	
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func configure(model: MediaItem) {
		guard let url = URL(string: model.artworkUrl100 ?? randomImage) else {return}
		imageView.kf.setImage(with: url)
	}
	
}
