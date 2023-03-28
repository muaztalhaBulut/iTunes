//
//  SearchViewController.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 24.03.2023.
//

import UIKit

protocol SearchOutput: AnyObject {
	func changeLoading(isLoad: Bool)
	func saveDatas(values: [MediaItem])
}

final class SearchViewController: UIViewController {
	private lazy var results: [MediaItem] = []
	private lazy var viewModel: SearchViewModelProtocol = SearchViewModel()
	private var query: String = ""
	private var mediaType: MediaType = .all
	private var offset: Int = 0
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let padding: CGFloat = 20
		let horizontalSpacing: CGFloat = 10
		let itemWidth = (view.bounds.width - padding * 2 - horizontalSpacing) / 2
		let itemHeight = itemWidth * 1.25
		layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
		layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		layout.minimumInteritemSpacing = horizontalSpacing
		layout.minimumLineSpacing = 10
		
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = .white
		return collectionView
	}()
	private lazy var segmentedControl: UISegmentedControl = {
		let segmentItems = ["All", "Movies", "Musics", "Apps", "Books"]
		let segmentedControl = UISegmentedControl(items: segmentItems)
		segmentedControl.selectedSegmentIndex = 0
		segmentedControl.addTarget(self, action: #selector(segmentedControl(_:)), for: .valueChanged)
		segmentedControl.selectedSegmentTintColor = .black
		segmentedControl.setTitleTextAttributes([
			NSAttributedString.Key.foregroundColor: UIColor.white,
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .semibold)
		], for: .selected)
		segmentedControl.setTitleTextAttributes([
			NSAttributedString.Key.foregroundColor: UIColor.black,
			NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .medium)
		], for: .normal)
		return segmentedControl
	}()
	
	private lazy var searchBar: UISearchBar = {
		let searchBar = UISearchBar()
		searchBar.placeholder = "Search"
		searchBar.delegate = self
		return searchBar
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		title = "iTunes Search"
		navigationController?.navigationBar.isHidden = false
		setupSearchBar()
		setSegment()
		setupCollectionView()
		viewModel.setDelegate(output: self)
		fetchData()
	}
	
	private func setupSearchBar() {
		view.addSubview(searchBar)
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		searchBar.setConstaints(
			top: view.safeAreaLayoutGuide.topAnchor,
			leading: view.leadingAnchor,
			trailing: view.trailingAnchor,
			topConstraint: 24,
			leadingConstraint: 16,
			trailingConstraint: 16,
			height: 44
		)
	}
	private func setSegment() {
		view.addSubview(segmentedControl)
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		segmentedControl.setConstaints(
			top: searchBar.bottomAnchor,
			leading: view.leadingAnchor,
			trailing: view.trailingAnchor,
			topConstraint: 10,
			leadingConstraint: 24,
			trailingConstraint: 24,
			height: 32
		)
	}
	private func setupCollectionView() {
		view.addSubview(collectionView)
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.Identifier.custom.rawValue)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.setConstaints(
			top: segmentedControl.bottomAnchor,
			leading: view.leadingAnchor,
			bottom: view.bottomAnchor,
			trailing: view.trailingAnchor,
			topConstraint: 16,
			leadingConstraint: .zero,
			bottomConstraint: .zero,
			trailingConstraint: .zero)
	}
	func fetchData() {
		guard let query = searchBar.text, !query.isEmpty else {
			results = []
			collectionView.reloadData()
			return
		}
		let mediaType = MediaType(segment: segmentedControl.selectedSegmentIndex) ?? .all
		viewModel.fetchData(query, mediaType: mediaType, limit: 20, offset: offset)
	}
	func resetResults() {
		offset = 0
		results.removeAll()
		collectionView.reloadData()
	}
	
	@objc
	func segmentedControl(_ sender: UISegmentedControl) {
		mediaType = MediaType(segment: sender.selectedSegmentIndex) ?? .all
		resetResults()
		fetchData()
	}
}

extension SearchViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.results.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.Identifier.custom.rawValue, for: indexPath) as! SearchCollectionViewCell
		cell.configure(model: self.results[indexPath.row])
		return cell
	}
}
extension SearchViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		let selectedResult = results[indexPath.row]
		let detailViewModel = DetailViewModel(mediaItem: selectedResult)
		let detailViewController = SearchDetailViewController(viewModel: detailViewModel)
		detailViewController.configure(with: detailViewModel)
		navigationController?.pushViewController(detailViewController, animated: true)
	}
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 5
	}
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		if indexPath.row == results.count - 1 {
			offset += 20
			viewModel.fetchData(query, mediaType: mediaType, limit: 20, offset: offset)
		}
	}
}
extension SearchViewController: SearchOutput {
	func changeLoading(isLoad: Bool) {
		isLoad ? LoadingManager.shared.show() : LoadingManager.shared.hide()
	}
	
	func saveDatas(values: [MediaItem]) {
		self.results.append(contentsOf: values)
		DispatchQueue.main.sync {
			self.collectionView.reloadData()
		}
	}
}

extension SearchViewController: UISearchBarDelegate {
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		if searchText.count >= 3 {
			query = searchText
			resetResults()
			fetchData()
		} else {
			query = ""
			resetResults()
		}
	}
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
	}
}

