//
//  SearchViewModel.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 24.03.2023.
//

import Foundation

protocol SearchViewModelProtocol {
	func fetchData(_ query: String)
	func setDelegate(output: SearchOutput)
	func changeLoading()
	
	var searchResult: [MediaItem] {get set}
	var searchService: ServiceProtocol {get}
	var searchOutPut: SearchOutput? {get}
}

final class SearchViewModel: SearchViewModelProtocol {
	var searchOutPut: SearchOutput?
	var searchService: ServiceProtocol
	var searchResult: [MediaItem] = []
	var isLoading = false
	
	init() {
		searchService = APIService()
	}
	func setDelegate(output: SearchOutput) {
		self.searchOutPut = output
	}
	func changeLoading() {
		isLoading = !isLoading
	}
	func fetchData(_ query: String) {
		isLoading = true
		searchService.request(route: APIRouter.search(term: query, media: MediaType.all, limit: 20, offset: 0), result: { [weak self] (result: Result<SearchResponseModel, ServiceError>) in
			guard let self = self else { return }
			self.isLoading = false
			self.searchOutPut?.changeLoading(isLoad: false)
			switch result {
			case .success(let response):
				self.searchResult = response.results ?? []
				self.searchOutPut?.saveDatas(values: self.searchResult)
				#if DEBUG
				print(response)
				#endif
			case .failure(let error):
				print("Error: \(error.localizedDescription)")
			}
		})
	}
	
	
}

