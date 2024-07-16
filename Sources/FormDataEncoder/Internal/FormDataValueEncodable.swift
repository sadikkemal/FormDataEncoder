//
//  FormDataValueEncodable.swift
//
//
//  Created by Sadık Kemal Sarı on 16.07.2024.
//

import Foundation

protocol FormDataValueEncodable {
	var data: Data { get }
}

extension FormDataValueEncodable where Self: CustomStringConvertible {
	var data: Data {
		Data(description.utf8)
	}
}

extension Bool: FormDataValueEncodable { }
extension String: FormDataValueEncodable { }
extension Double: FormDataValueEncodable { }
extension Float: FormDataValueEncodable { }
extension Int: FormDataValueEncodable { }
extension Int8: FormDataValueEncodable { }
extension Int16: FormDataValueEncodable { }
extension Int32: FormDataValueEncodable { }
extension Int64: FormDataValueEncodable { }
extension UInt: FormDataValueEncodable { }
extension UInt8: FormDataValueEncodable { }
extension UInt16: FormDataValueEncodable { }
extension UInt32: FormDataValueEncodable { }
extension UInt64: FormDataValueEncodable { }
