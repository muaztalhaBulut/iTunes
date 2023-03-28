//
//  Date+Ext.swift
//  iTunes
//
//  Created by Talha on 28.03.2023.
//

import Foundation

extension String {
	func formattedString() -> String {
		let dateFormatterGet = DateFormatter()
		dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		let date: Date? = dateFormatterGet.date(from: self)
		return dateFormatter.string(from: date!)
	}
}
