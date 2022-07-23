import struct os.log.Logger
import AuthenticationServices

public struct AppleKeychain: Keychain, Sendable {
    let logger: Optional<Logger>

    public init(logger: Optional<Logger> = nil) {
        self.logger = logger
    }

    public init(subsystem: String, category: String = "composable-authentication-service") {
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    public func addSecret(withAttributes attributes: [String: Any]) throws -> Bool {
         let status = SecItemAdd(attributes as CFDictionary, nil)
         switch status {
            case errSecSuccess: return true
            case errSecDuplicateItem: return false
            default: throw Error(unexpectedStatus: status)
         }
    }
    func updateSecret(_ query: [String: Any], with attributesToUpdate: [String: Any]) throws -> Bool {
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
         switch status {
            case errSecSuccess: return true
            case errSecItemNotFound: return false
            default: throw Error(unexpectedStatus: status)
         }
    }
    func deleteSecret(_ query: [String: Any]) throws -> Bool {
        let status = SecItemDelete(query as CFDictionary)
        switch status {
            case errSecSuccess: return true
            case errSecItemNotFound: return false
            default: throw Error(unexpectedStatus: status)
         }
    }

    func retrieveSecret(withAttributes attributes: [String: Any]) throws -> [String : Any] {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        switch status {
        case errSecSuccess:
            if let existingItem = item as? [String : Any] {
                return existingItem
            } else {
                throw Error.unexpectedSecretData
            }
        case errSecItemNotFound: throw Error.secretNotFound
        default:  throw Error(unexpectedStatus: status)
    }

    public enum Error: Swift.Error, Sendable, Equatable, Hashable {
        case secretNotFound
        case unexpectedSecretData
        case unexpectedError(message: Optional<String>)

        init(unexpectedStatus: OSStatus) {
            let message = SecCopyErrorMessageString(unexpectedStatus, nil).map { $0 as String }
            self = .unexpectedError(message: message)
        }
    }
}
