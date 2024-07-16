//
//  FormDataKeyedEncodingContainer.swift
//
//
//  Created by Sadık Kemal Sarı on 16.07.2024.
//

import Foundation

/// A container for encoding keyed values in multipart/form-data format.
struct FormDataKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
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

	func encodeNil(forKey key: Key) throws { }

	func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
		if let valueEncodable = value as? FormDataValueEncodable {
			body.append(valueEncodable, codingPath: codingPath + [key])
			return
		}
		if let fileEncodable = value as? FormDataFileEncodable {
			body.append(fileEncodable, codingPath: codingPath + [key])
			return
		}
		let coreEncoder = FormDataCoreEncoder(
			codingPath: codingPath + [key],
			userInfo: userInfo,
			body: body
		)
		try value.encode(to: coreEncoder)
	}

	mutating func nestedContainer<NestedKey: CodingKey>(
		keyedBy keyType: NestedKey.Type,
		forKey key: Key
	) -> KeyedEncodingContainer<NestedKey> {
		let container = FormDataKeyedEncodingContainer<NestedKey>(
			codingPath: codingPath + [key],
			userInfo: userInfo,
			body: body)
		return KeyedEncodingContainer(container)
	}

	mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
		let container = FormDataUnkeyedEncodingContainer(
			codingPath: codingPath + [key],
			userInfo: userInfo,
			body: body)
		return container
	}

	mutating func superEncoder() -> Encoder {
		// swiftlint:disable:next force_unwrapping
		let superKey = Key(stringValue: "super")!
		return superEncoder(forKey: superKey)
	}

	mutating func superEncoder(forKey key: Key) -> Encoder {
		let coreEncoder = FormDataCoreEncoder(
			codingPath: codingPath + [key],
			userInfo: userInfo,
			body: body)
		return coreEncoder
	}
}
