//
//  FormDataCoreEncoder.swift
//
//
//  Created by Sadık Kemal Sarı on 16.07.2024.
//

import Foundation

/// A core encoder for handling the encoding process of multipart/form-data.
struct FormDataCoreEncoder: Encoder {
	private(set) var codingPath: [CodingKey]
	private(set) var userInfo: [CodingUserInfoKey: Any]
	private(set) var body: FormDataBody

	func container<Key: CodingKey>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> {
		let container = FormDataKeyedEncodingContainer<Key>(
			codingPath: codingPath,
			userInfo: userInfo,
			body: body)
		return KeyedEncodingContainer(container)
	}

	func unkeyedContainer() -> UnkeyedEncodingContainer {
		let container = FormDataUnkeyedEncodingContainer(
			codingPath: codingPath,
			userInfo: userInfo,
			body: body)
		return container
	}

	func singleValueContainer() -> SingleValueEncodingContainer {
		let container = FormDataSingleValueEncodingContainer(
			codingPath: codingPath,
			userInfo: userInfo,
			body: body)
		return container
	}
}
