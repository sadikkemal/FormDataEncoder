//
//  FormDataSingleValueEncodingContainer.swift
//
//
//  Created by Sadık Kemal Sarı on 16.07.2024.
//

import Foundation

/// A container for encoding single values in multipart/form-data format.
struct FormDataSingleValueEncodingContainer: SingleValueEncodingContainer {
	private(set) var codingPath: [CodingKey]
	private(set) var userInfo: [CodingUserInfoKey: Any]
	private var body: FormDataBody

	init(
		codingPath: [CodingKey],
		userInfo: [CodingUserInfoKey: Any],
		body: FormDataBody
	) {
		self.codingPath = codingPath
		self.userInfo = userInfo
		self.body = body
	}

	mutating func encodeNil() throws { }

	mutating func encode<T: Encodable>(_ value: T) throws {
		if let valueEncodable = value as? FormDataValueEncodable {
			body.append(valueEncodable, codingPath: codingPath)
			return
		}
		if let fileEncodable = value as? FormDataFileEncodable {
			body.append(fileEncodable, codingPath: codingPath)
			return
		}
		let coreEncoder = FormDataCoreEncoder(
			codingPath: codingPath,
			userInfo: userInfo,
			body: body)
		try value.encode(to: coreEncoder)
	}
}
