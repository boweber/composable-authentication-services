public protocol Keychain: Sendable {
    /// Returns `true`, if the item was successfully saved. 
    /// Returns `false`, if the item already exists.
    func saveSecret(withAttributes attributes: [String: Any]) throws -> Bool
    /// Returns `true`, if the item was successfully updated. 
    /// Returns `false`, if the item was not found.
    func updateSecret(_ query: [String: Any], with attributesToUpdate: [String: Any]) throws -> Bool
    /// Returns `true`, if the item was successfully deleted.
    /// Returns `false`, if the item was not found.
    func deleteSecret(_ query: [String: Any]) throws -> Bool
    /// Returns a dictionary containing the secret's data.
    func retrieveSecret(withAttributes attributes: [String: Any]) throws -> [String : Any]
}