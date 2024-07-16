import XCTest
@testable import FormDataEncoder

class FormDataEncoderTests: XCTestCase {
	func test_encode_nil_shouldReturnEmptyData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(Optional<String>.none)
		XCTAssertEqual(data.count, 0, "Encoded data should be greater than zero bytes.")
	}

	func test_encode_bool_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(true)
		let expectedData = buildData(
			name: "value",
			data: "true")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_string_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode("string")
		let expectedData = buildData(
			name: "value",
			data: "string")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_double_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(Double(123.123))
		let expectedData = buildData(
			name: "value",
			data: "123.123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_float_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(Float(123.123))
		let expectedData = buildData(
			name: "value",
			data: "123.123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_int_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(Int(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_int8_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(Int8(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_int16_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(Int16(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_int32_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(Int32(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_int64_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(Int64(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_uint_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(UInt(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_uint8_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(UInt8(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_uint16_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(UInt16(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_uint32_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(UInt32(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_uint64_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(UInt64(123))
		let expectedData = buildData(
			name: "value",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_oneLevelKeyedValue_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			let name: String
		}

		let encoder = FormDataEncoder()
		let person = Employee(name: "John")
		let data = try encoder.encode(person)
		let expectedData = buildData(
			name: "name",
			data: "John")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_oneLevelKeyedFile_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			let picture: FormDataFile
		}

		let picture = FormDataFile(
			fileName: "picture.jpeg",
			mimeType: "image/jpeg",
			data: Data("picture content".utf8))
		let employee = Employee(picture: picture)
		let encoder = FormDataEncoder()
		let data = try encoder.encode(employee)
		let expectedData = buildData(
			name: "picture",
			filename: "picture.jpeg",
			contentType: "image/jpeg",
			data: Data("picture content".utf8))
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_twoLevelKeyedValueDotSeparator_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			let company: Company
		}

		struct Company: Encodable {
			let name: String
		}

		let company = Company(name: "Apple")
		let employee = Employee(company: company)
		let encoder = FormDataEncoder()
		let data = try encoder.encode(employee)
		let expectedData = buildData(
			name: "company.name",
			data: "Apple")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_twoLevelKeyedValueDashSeparator_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			let company: Company
		}

		struct Company: Encodable {
			let name: String
		}

		let company = Company(name: "Apple")
		let employee = Employee(company: company)
		var encoder = FormDataEncoder()
		encoder.nestedKeySeparator = "-"
		let data = try encoder.encode(employee)
		let expectedData = buildData(
			name: "company-name",
			data: "Apple")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_twoLevelKeyedFile_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			let resume: Resume
		}

		struct Resume: Encodable {
			let picture: FormDataFile
		}

		let picture = FormDataFile(
			fileName: "picture.jpeg",
			mimeType: "image/jpeg",
			data: Data("picture content".utf8))
		let resume = Resume(picture: picture)
		let employee = Employee(resume: resume)
		let encoder = FormDataEncoder()
		let data = try encoder.encode(employee)
		let expectedData = buildData(
			name: "resume.picture",
			filename: "picture.jpeg",
			contentType: "image/jpeg",
			data: Data("picture content".utf8))
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_oneLevelUnkeyedValue_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode(["John"])
		let expectedData = buildData(
			name: "0",
			data: "John")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_oneLevelUnkeyedFile_shouldContainEncodedData() throws {
		let picture = FormDataFile(
			fileName: "picture.jpeg",
			mimeType: "image/jpeg",
			data: Data("picture content".utf8))
		let encoder = FormDataEncoder()
		let data = try encoder.encode([picture])
		let expectedData = buildData(
			name: "0",
			filename: "picture.jpeg",
			contentType: "image/jpeg",
			data: Data("picture content".utf8))
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_twoLevelUnkeyedValueDotSeparator_shouldContainEncodedData() throws {
		let encoder = FormDataEncoder()
		let data = try encoder.encode([["John"]])
		let expectedData = buildData(
			name: "0.0",
			data: "John")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_twoLevelUnkeyedValueDashSeparator_shouldContainEncodedData() throws {
		var encoder = FormDataEncoder()
		encoder.nestedKeySeparator = "-"
		let data = try encoder.encode([["John"]])
		let expectedData = buildData(
			name: "0-0",
			data: "John")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_oneLevelKeyedOneLevelUnkeyedValue_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			let departmants: [String]
		}

		let employee = Employee(departmants: ["I.T."])
		let encoder = FormDataEncoder()
		let data = try encoder.encode(employee)
		let expectedData = buildData(
			name: "departmants.0",
			data: "I.T.")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_oneLevelKeyedOneLevelUnkeyedFile_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			let files: [FormDataFile]
		}

		let picture = FormDataFile(
			fileName: "picture.jpeg",
			mimeType: "image/jpeg",
			data: Data("picture content".utf8))
		let employee = Employee(files: [picture])
		let encoder = FormDataEncoder()
		let data = try encoder.encode(employee)
		let expectedData = buildData(
			name: "files.0",
			filename: "picture.jpeg",
			contentType: "image/jpeg",
			data: Data("picture content".utf8))
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_twoLevelKeyedCustomKeyedValue_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			enum CodingKeys: String, CodingKey {
				case id = "ID"
			}

			let id: Int
		}

		let employee = Employee(id: 123)
		let encoder = FormDataEncoder()
		let data = try encoder.encode(employee)
		let expectedData = buildData(
			name: "ID",
			data: "123")
		XCTAssertNotNil(data.range(of: expectedData))
	}

	func test_encode_twoLevelKeyedCustomEncodableValue_shouldContainEncodedData() throws {
		struct Employee: Encodable {
			enum CodingKeys: String, CodingKey {
				case additionalInfo
			}

			enum AdditionalInfoKeys: String, CodingKey {
				case age
			}

			let age: Int

			func encode(to encoder: Encoder) throws {
				var container = encoder.container(keyedBy: CodingKeys.self)
				var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
				try additionalInfo.encode(age, forKey: .age)
			}
		}

		let employee = Employee(age: 32)
		let encoder = FormDataEncoder()
		let data = try encoder.encode(employee)
		let expectedData = buildData(
			name: "additionalInfo.age",
			data: "32")
		XCTAssertNotNil(data.range(of: expectedData))
	}
}

private extension FormDataEncoderTests {
	func buildData(
		name: String,
		data: String
	) -> Data {
		var expectedData = Data()
		expectedData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
		expectedData.append("\r\n")
		expectedData.append(data)
		expectedData.append("\r\n")
		return expectedData
	}

	func buildData(
		name: String,
		filename: String,
		contentType: String,
		data: Data
	) -> Data {
		var expectedData = Data()
		expectedData.append("Content-Disposition: form-data; name=\"\(name)\";")
		expectedData.append(" filename=\"\(filename)\"\r\n")
		expectedData.append("Content-Type: \(contentType)\r\n")
		expectedData.append("\r\n")
		expectedData.append(data)
		expectedData.append("\r\n")
		return expectedData
	}
}

private extension Data {
	mutating func append(_ string: String) {
		append(Data(string.utf8))
	}
}
