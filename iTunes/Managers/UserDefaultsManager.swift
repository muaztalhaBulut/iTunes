//
//  UserDefaultsManager.swift
//  iTunesAppCodeChallenge
//
//  Created by Talha on 22.03.2023.
//


import Foundation

class UserDefaultsManager {
	
	private let userDefaults: UserDefaults
	
	init(userDefaults: UserDefaults = UserDefaults.standard) {
		self.userDefaults = userDefaults
	}
	
	// MARK: - Setters
	
	func set<T: Codable>(_ value: T?, forKey key: String) {
		guard let value = value else {
			userDefaults.removeObject(forKey: key)
			return
		}
		
		do {
			let data = try JSONEncoder().encode(value)
			userDefaults.set(data, forKey: key)
		} catch {
			print("Error encoding value for key \(key): \(error)")
		}
	}
	
	func set(_ value: Any?, forKey key: String) {
		userDefaults.set(value, forKey: key)
	}
	
	// MARK: - Getters
	
	func value<T: Codable>(forKey key: String) -> T? {
		guard let data = userDefaults.data(forKey: key) else {
			return nil
		}
		
		do {
			let value = try JSONDecoder().decode(T.self, from: data)
			return value
		} catch {
			print("Error decoding value for key \(key): \(error)")
			return nil
		}
	}
	
	func string(forKey key: String) -> String? {
		return userDefaults.string(forKey: key)
	}
	
	func integer(forKey key: String) -> Int {
		return userDefaults.integer(forKey: key)
	}
	
	func float(forKey key: String) -> Float {
		return userDefaults.float(forKey: key)
	}
	
	func double(forKey key: String) -> Double {
		return userDefaults.double(forKey: key)
	}
	
	func bool(forKey key: String) -> Bool {
		return userDefaults.bool(forKey: key)
	}
	
	// MARK: - Deletion
	
	func removeObject(forKey key: String) {
		userDefaults.removeObject(forKey: key)
	}
	
	func removeAll() {
		let domain = Bundle.main.bundleIdentifier!
		userDefaults.removePersistentDomain(forName: domain)
		userDefaults.synchronize()
	}
}
