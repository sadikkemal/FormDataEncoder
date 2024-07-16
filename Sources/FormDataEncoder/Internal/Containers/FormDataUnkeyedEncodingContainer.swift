//
//  FormDataUnkeyedEncodingContainer.swift
//
//
//  Created by Sadık Kemal Sarı on 16.07.2024.
//

import Foundation

/// A container for encoding unkeyed values in multipart/form-data format.
struct FormDataUnkeyedEncodingContainer: UnkeyedEncodingContainer {
	private struct IndexedCodingKey: CodingKey {
		let intValue: Int?
		let stringValue: String

		init(intValue: Int) {
			self.intValue = intValue
			self.stringValue = intValue.description
		}

		init(stringValue: String) {
			self.intValue = nil
			self.stringValue = stringValue
		}
	}

	private(set) var codingPath: [CodingKey]
	private(set) var userInfo: [CodingUserInfoKey: Any]
	private(set) var count: Int
	private var body: FormDataBody

	init(
		codingPath: [CodingKey],
		userInfo: [CodingUserInfoKey: Any],
		count: Int = 0,
		body: FormDataBody
	) {
		self.codingPath = codingPath
		self.userInfo = userInfo
		self.count = count
		self.body = body
	}

	private mutating func nextIndexedKey() -> CodingKey {
		let nextCodingKey = IndexedCodingKey(intValue: count)
		count += 1
		return nextCodingKey
	}

	mutating func encodeNil() throws { }

	mutating func encode<T: Encodable>(_ value: T) throws {
		if let valueEncodable = value as? FormDataValueEncodable {
			body.append(valueEncodable, codingPath: codingPath + [nextIndexedKey()])
			return
		}
		if let fileEncodable = value as? FormDataFileEncodable {
			body.append(fileEncodable, codingPath: codingPath + [nextIndexedKey()])
			return
		}
		let coreEncoder = FormDataCoreEncoder(
			codingPath: codingPath + [nextIndexedKey()],
			userInfo: userInfo,
			body: body)
		try value.encode(to: coreEncoder)
	}

	mutating func nestedContainer<NestedKey: CodingKey>(
		keyedBy keyType: NestedKey.Type
	) -> KeyedEncodingContainer<NestedKey> {
		let container = FormDataKeyedEncodingContainer<NestedKey>(
			codingPath: codingPath + [nextIndexedKey()],
			userInfo: userInfo,
			body: body)
		return KeyedEncodingContainer(container)
	}

	mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
		let container = FormDataUnkeyedEncodingContainer(
			codingPath: codingPath + [nextIndexedKey()],
			userInfo: userInfo,
			body: body)
		return container
	}

	mutating func superEncoder() -> Encoder {
		let coreEncoder = FormDataCoreEncoder(
			codingPath: codingPath + [nextIndexedKey()],
			userInfo: userInfo,
			body: body)
		return coreEncoder
	}
}
