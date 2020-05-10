import Foundation

public protocol LocalizableError: Error {

    var bundle: Bundle { get }
    var table: String { get }
}

extension LocalizableError {

    var bundle: Bundle {

        return .main
    }

    var table: String {

        return "LocalizableErrors"
    }

    var localizedDescription: String {

        let mirror = Mirror(reflecting: self)

        switch mirror.children.first {

        case .none:
            return "\(String(reflecting: type(of: self))).\(String(describing: self))"

        case .some(_, let childLocalizableError as LocalizableError):
            return childLocalizableError.localizedDescription

        case .some(_, let childLocalizedError as LocalizedError):
            return childLocalizedError.errorDescription ?? childLocalizedError.localizedDescription

        case .some(_, let childError as Error):
            return childError.localizedDescription

        case .some(_, let childMessage as String) where !childMessage.isEmpty:
            return childMessage

        case .some(.some(let key), _):
            return "\(String(reflecting: type(of: self))).\(key)"

        default:
            return "\(String(reflecting: type(of: self)))"
        }
    }
}

enum SomeError: LocalizableError {

    case invalid
    case unknown
    case network(LocalizableError)
    case generic(Error)
    case alreadyLocalized(String)
    case mightBeLocalized(String?)
}

enum Something {

    enum Error: LocalizableError {

        case something
    }
}

SomeError.unknown.localizedDescription
SomeError.invalid.localizedDescription
SomeError.network(SomeError.invalid).localizedDescription
SomeError.generic(SomeError.invalid).localizedDescription
SomeError.generic(NSError(domain: "", code: -1, userInfo: nil)).localizedDescription
SomeError.alreadyLocalized("My error already localized").localizedDescription
SomeError.mightBeLocalized("My error localized, maybe").localizedDescription
SomeError.mightBeLocalized("").localizedDescription
SomeError.mightBeLocalized(nil).localizedDescription
Something.Error.something.localizedDescription

String(reflecting: Something.Error.self)
