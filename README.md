# FormDataEncoder Swift Package

The `FormDataEncoder` Swift package provides a simple and flexible way to encode `Encodable` values into `multipart/form-data` format. This is particularly useful for uploading files and data to web servers in a format that they can easily parse.

## Features

- Encode `Encodable` types to `multipart/form-data`
- Support for both simple values and file uploads
- Customizable boundary and nested key separator
- Conformance to Swift's `Encodable` and `CodingKey` protocols

## Installation

### Swift Package Manager

Add the following line to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/sadikkemal/FormDataEncoder.git", from: "1.0.0")
]
```

Then, import the package in your Swift code:

```swift
import FormDataEncoder
```

## Usage

### Encoding Values

To encode simple  `Encodable`  values, use the  `FormDataEncoder`:

```swift
import FormDataEncoder

struct User: Encodable {
    let name: String
    let age: Int
}

let user = User(name: "John Doe", age: 30)
let encoder = FormDataEncoder()
let data = try encoder.encode(user)
```

Expected Output:
```
--<boundary>
Content-Disposition: form-data; name="name"

John Doe
--<boundary>
Content-Disposition: form-data; name="age"

30
--<boundary>--
```

### Encoding Files

To upload files, conform your file type to  `FormDataFileEncodable`:

```swift
import FormDataEncoder

struct ProfilePicture: Encodable {
    let image: FormDataFile
}

let imageData = Data() // Your image data here
let file = FormDataFile(fileName: "profile.jpg", mimeType: "image/jpeg", data: imageData)
let profilePicture = ProfilePicture(image: file)

let encoder = FormDataEncoder()
let data = try encoder.encode(profilePicture)
```

Expected Output:
```
--<boundary>
Content-Disposition: form-data; name="image"; filename="profile.jpg"
Content-Type: image/jpeg

<binary data>
--<boundary>--
```

### Customizing Boundary and Key Separator

You can customize the boundary and nested key separator used in the encoding process:

```swift
var encoder = FormDataEncoder()
encoder.boundary = "CustomBoundary"
encoder.nestedKeySeparator = "-"
let data = try encoder.encode(user)
```

## Licenses

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.
