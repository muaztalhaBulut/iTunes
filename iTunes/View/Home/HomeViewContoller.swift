//
//  HomeViewContoller.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 24.03.2023.
//

import UIKit

protocol SearchOutput {
	func changeLoading(isLoad: Bool)
	func saveDatas(values: [MediaItem])
}

class HomeViewContoller: UIViewController {
	
	private lazy var results: [MediaItem] = []
	private lazy var viewModel: SearchViewModelProtocol = SearchViewModel()
	
	private lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let itemWidth = floor((view.bounds.width - layout.minimumInteritemSpacing * 3) / 4)
		layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
		layout.minimumInteritemSpacing = 5
		layout.minimumLineSpacing = 5
		
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
		viewModel.fetchData(searchBar.text ?? "")
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
	@objc
	func segmentedControl(_ sender: UISegmentedControl) {
		let selectedSegmentIndex = sender.selectedSegmentIndex
		guard let mediaType = MediaType(segment: selectedSegmentIndex) else { return }
		
		collectionView.scrollToItem(at: .init(row: .zero, section: .zero), at: .centeredVertically, animated: true)
	}
}

extension HomeViewContoller: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// Return the number of items you want to display in the collection view
		return results.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.Identifier.custom.rawValue, for: indexPath) as! SearchCollectionViewCell
		cell.configure(model: results[indexPath.row])
		return cell
	}
}

extension HomeViewContoller: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 5
	}
}
extension HomeViewContoller: SearchOutput {
	func changeLoading(isLoad: Bool) {
		isLoad ? LoadingManager.shared.show() : LoadingManager.shared.hide()
	}
	
	func saveDatas(values: [MediaItem]) {
		results = values
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
}

extension HomeViewContoller: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchBar.resignFirstResponder()
		viewModel.fetchData(searchBar.text ?? "")
	}
}
