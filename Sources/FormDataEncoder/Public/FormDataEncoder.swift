//
//  FormDataEncoder.swift
//
//
//  Created by Sadık Kemal Sarı on 16.07.2024.
//

import Foundation

/// A struct responsible for encoding `Encodable` values into multipart/form-data format.
public struct FormDataEncoder {
	public var boundary: String = UUID().uuidString
	public var nestedKeySeparator: String = "."
	public var userInfo: [CodingUserInfoKey: Any] = .init()

	public init() { }

	/// Encodes an `Encodable` value into `Data` using multipart/form-data format.
	/// - Parameter value: The `Encodable` value to be encoded.
	/// - Throws: Encoding error if the value cannot be encoded.
	/// - Returns: Encoded `Data` in multipart/form-data format.
	public func encode<T: Encodable>(_ value: T) throws -> Data {
		let body = FormDataBody(
			boundary: boundary,
			nestedKeySeparator: nestedKeySeparator)
		let coreEncoder = FormDataCoreEncoder(
			codingPath: .init(),
			userInfo: userInfo,
			body: body)
		try value.encode(to: coreEncoder)
		return body.data
	}
}
