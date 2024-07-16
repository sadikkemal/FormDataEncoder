//
//  FormDataBody.swift
//
//
//  Created by Sadık Kemal Sarı on 16.07.2024.
//

import Foundation

/// A class responsible for constructing the multipart/form-data body.
final class FormDataBody {
	private(set) var data: Data
	private let boundary: String
	private let nestedKeySeparator: String

	init(
		boundary: String,
		nestedKeySeparator: String
	) {
		self.data = .init()
		self.boundary = boundary
		self.nestedKeySeparator = nestedKeySeparator
	}
}

// MARK: - API
extension FormDataBody {
	/// Appends a simple value to the form-data body.
	/// - Parameters:
	///   - value: The value to be appended.
	///   - codingPath: The coding path of the value.
	func append<T: FormDataValueEncodable>(_ value: T, codingPath: [CodingKey]) {
		var key = key(for: codingPath)
		key = key.isEmpty ? "value" : key
		var data = Data()
		data.append("--\(boundary)\r\n")
		data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
		data.append(value.data)
		data.append("\r\n")
		append(valueData: data)
	}

	/// Appends a file to the form-data body.
	/// - Parameters:
	///   - value: The file to be appended.
	///   - codingPath: The coding path of the file.
	func append<T: FormDataFileEncodable>(_ value: T, codingPath: [CodingKey]) {
		var key = key(for: codingPath)
		key = key.isEmpty ? "file" : key
		var data = Data()
		data.append("--\(boundary)\r\n")
		data.append("Content-Disposition: form-data; name=\"\(key)\";")
		data.append(" filename=\"\(value.fileName)\"")
		data.append("\r\n")
		data.append("Content-Type: \(value.mimeType)\r\n\r\n")
		data.append(value.data)
		data.append("\r\n")
		append(valueData: data)
	}
}

// MARK: - Helpers
private extension FormDataBody {
	/// Generates the key for a given coding path.
	/// - Parameter codingPath: The coding path.
	/// - Returns: The key as a string.
	func key(for codingPath: [CodingKey]) -> String {
		let key = codingPath
			.map { $0.stringValue }
			.joined(separator: nestedKeySeparator)
		return key
	}

	/// Appends data to the form-data body.
	/// - Parameter valueData: The data to be appended.
	func append(valueData: Data) {
		let endOfBody = Data("--\(boundary)--\r\n".utf8)
		let range = data.range(of: endOfBody)
		if let range {
			data.insert(contentsOf: valueData, at: range.startIndex)
		} else {
			data.append(valueData)
			data.append(endOfBody)
		}
	}
}

// MARK: - Data
private extension Data {
	/// Appends a string to the data.
	/// - Parameter string: The string to be appended.
	mutating func append(_ string: String) {
		append(Data(string.utf8))
	}
}
