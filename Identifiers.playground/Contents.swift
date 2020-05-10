import Foundation

protocol TypeSafeIdentifiable {

    associatedtype RawIdentifier: Hashable

    var id: Identifier<Self> { get }
}

struct Identifier<Value: TypeSafeIdentifiable>: Hashable {

    var value: Value.RawIdentifier
}

extension Identifier: Decodable where Value.RawIdentifier: Decodable {

    init(from decoder: Decoder) throws {

        let container = try decoder.singleValueContainer()
        self.value = try container.decode(Value.RawIdentifier.self)
    }
}

extension Identifier: Encodable where Value.RawIdentifier: Encodable {

    func encode(to encoder: Encoder) throws {

        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

extension Identifier: CustomStringConvertible where Value.RawIdentifier: CustomStringConvertible {

    var description: String {

        return String(describing: value)
    }
}

extension Identifier: ExpressibleByUnicodeScalarLiteral where Value.RawIdentifier: ExpressibleByUnicodeScalarLiteral {

    init(unicodeScalarLiteral value: Value.RawIdentifier.UnicodeScalarLiteralType) {

        self.value = Value.RawIdentifier(unicodeScalarLiteral: value)
    }
}

extension Identifier: ExpressibleByExtendedGraphemeClusterLiteral where Value.RawIdentifier: ExpressibleByExtendedGraphemeClusterLiteral {

    init(extendedGraphemeClusterLiteral value: Value.RawIdentifier.ExtendedGraphemeClusterLiteralType) {

        self.value = Value.RawIdentifier(extendedGraphemeClusterLiteral: value)
    }
}

extension Identifier: ExpressibleByStringLiteral where Value.RawIdentifier: ExpressibleByStringLiteral {

    init(stringLiteral value: Value.RawIdentifier.StringLiteralType) {

        self.value = Value.RawIdentifier(stringLiteral: value)
    }
}

extension Identifier: ExpressibleByIntegerLiteral where Value.RawIdentifier: ExpressibleByIntegerLiteral {

    init(integerLiteral value: Value.RawIdentifier.IntegerLiteralType) {

        self.value = Value.RawIdentifier(integerLiteral: value)
    }
}

struct User: TypeSafeIdentifiable {

    typealias RawIdentifier = String

    let id: Identifier<User>
    let name: String
}

struct Group: TypeSafeIdentifiable {

    typealias RawIdentifier = Int

    let id: Identifier<Group>
    let name: String
}

func someDummyFunction(withUser userId: Identifier<User>) {

    print("This is the user \(userId)")
}

func someDummyFunction(withGroup groupId: Identifier<Group>) {

    print("This is the group \(groupId)")
}

let user = User(id: "id", name: "name")
let group = Group(id: 1, name: "group")

someDummyFunction(withUser: user.id)
//someDummyFunction(withUser: group.id) fails
someDummyFunction(withGroup: group.id)
//someDummyFunction(withGroup: user.id) fails

class Something {

    let name: String = ""
}

Mirror(reflecting: (\Something.name))

