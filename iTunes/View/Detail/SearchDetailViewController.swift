//
//  SearchDetailViewController.swift
//  iTunes
//
//  Created by Talha on 28.03.2023.
//

import UIKit
import Kingfisher

final class SearchDetailViewController: UIViewController {
	private var viewModel: DetailViewModel!
	
	private lazy var artworkImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()
	private lazy var collectionNameLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .left
		label.textColor = .black
		return label
	}()
	private lazy var countryLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .left
		label.textColor = .black
		return label
	}()
	private lazy var releaseDateLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .left
		label.textColor = .black
		return label
	}()
	private lazy var contentStackView: UIStackView = {
		let stackView = UIStackView(arrangedSubviews: [collectionNameLabel, countryLabel, releaseDateLabel])
		stackView.axis = .vertical
		stackView.spacing = 5
		stackView.alignment = .fill
		stackView.distribution = .fillEqually
		stackView.translatesAutoresizingMaskIntoConstraints = false
		return stackView
	}()
	
	init(viewModel: DetailViewModel!) {
			super.init(nibName: nil, bundle: nil)
			self.viewModel = viewModel
		}
		
		required init?(coder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Detail"
		view.backgroundColor = .white
		configureUIComponent()
	}
	func configure(with viewModel: DetailViewModel) {
		self.viewModel = viewModel
		self.artworkImageView.kf.setImage(with: URL(string: viewModel.artworkUrl100))
		self.collectionNameLabel.text = "Collection Name: \(viewModel.collectionName)"
		self.countryLabel.text = "Country: \(viewModel.country)"
		self.releaseDateLabel.text = "Release Date: \(viewModel.releaseDate)"
	}
	private func configureUIComponent() {
		view.addSubview(artworkImageView)
		view.addSubview(contentStackView)
		contentStackView.addArrangedSubview(collectionNameLabel)
		contentStackView.addArrangedSubview(countryLabel)
		contentStackView.addArrangedSubview(releaseDateLabel)
		
		contentStackView.translatesAutoresizingMaskIntoConstraints = false
		artworkImageView.translatesAutoresizingMaskIntoConstraints = false
		collectionNameLabel.translatesAutoresizingMaskIntoConstraints = false
		countryLabel.translatesAutoresizingMaskIntoConstraints = false
		releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
		
		artworkImageView.setConstaints(
			top: view.safeAreaLayoutGuide.topAnchor,
			topConstraint: 25,
			centerX: view.centerXAnchor,
			width: 100,
			height: 150
		)
		contentStackView.setConstaints(
			top: artworkImageView.bottomAnchor,
			leading: view.leadingAnchor,
			trailing: view.trailingAnchor,
			topConstraint: 10,
			leadingConstraint: 20,
			trailingConstraint: 20,
			centerX: view.centerXAnchor)
	}
}
