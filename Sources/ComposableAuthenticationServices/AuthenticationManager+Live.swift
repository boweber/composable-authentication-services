import AuthenticationServices

extension AuthenticationManager {
    public static let live = AuthenticationManager { password, server, account in
        guard let secret = password.data(using: String.Encoding.utf8) else {
            throw Error.failedToEncodeString
        }
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecAttrAccount as String: account,
            kSecValueData as String: secret
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        switch status {
        case errSecSuccess: return
        case errSecDuplicateItem:
            let updateQuery: [String: Any] = [
                kSecClass as String: kSecClassInternetPassword,
                kSecAttrServer as String: server,
            ]
            let attributes: [String: Any] = [
                kSecAttrAccount as String: account,
                kSecValueData as String: secret
            ]
            let updateStatus = SecItemUpdate(updateQuery as CFDictionary, attributes as CFDictionary)
            switch updateStatus {
            case errSecSuccess:
                return
            case errSecItemNotFound:
                fatalError("Update of a Key marked as duplicate resulted in item-not-found error message")
            default:
                let message = SecCopyErrorMessageString(updateStatus, nil).map { $0 as String }
                throw Error.unhandledError(status: status, message: message)
            }
        default:
            let message = SecCopyErrorMessageString(status, nil).map { $0 as String }
            throw Error.unhandledError(status: status, message: message)
        }
    } deleteInternetPassword: { server, account in
        var query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server
        ]
        if let account {
            query[kSecAttrAccount as String] = account
        }
        let status = SecItemDelete(query as CFDictionary)
        switch status {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            assertionFailure("Tried to delete an unknown key from Keychain")
            return
        default:
            let message = SecCopyErrorMessageString(status, nil).map { $0 as String }
            throw Error.unhandledError(status: status, message: message)
        }
    } readInternetPassword: { server, account in
        var query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: server,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        if let account {
            query[kSecAttrAccount as String] = account
        }
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        switch status {
        case errSecSuccess:
            if let existingItem = item as? [String : Any],
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: String.Encoding.utf8),
               let account = existingItem[kSecAttrAccount as String] as? String {
                return (account, password)
            } else {
                throw Error.unexpectedPasswordData
            }
        case errSecItemNotFound:
            throw Error.noPassword
        default:
            let message = SecCopyErrorMessageString(status, nil).map { $0 as String }
            throw Error.unhandledError(status: status, message: message)
        }
    }
    
    public enum Error: Swift.Error, Sendable, Equatable, Hashable {
        case failedToEncodeString
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus, message: Optional<String> = nil)
    }
}
