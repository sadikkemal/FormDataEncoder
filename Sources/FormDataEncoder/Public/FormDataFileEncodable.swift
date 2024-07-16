//
//  FormDataFile.swift
//
//
//  Created by Sadık Kemal Sarı on 16.07.2024.
//

import Foundation

/// Struct representing a file for multipart/form-data encoding.
public struct FormDataFile: Encodable, FormDataFileEncodable {
	public var fileName: String
	public var mimeType: String
	public var data: Data

	public init(
		fileName: String,
		mimeType: String,
		data: Data
	) {
		self.fileName = fileName
		self.mimeType = mimeType
		self.data = data
	}
}

/// Protocol for representing a file in multipart/form-data encoding.
public protocol FormDataFileEncodable {
	var fileName: String { get }
	var mimeType: String { get }
	var data: Data { get }
}
