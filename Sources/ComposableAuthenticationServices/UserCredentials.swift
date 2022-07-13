public struct UserCredentials: Sendable, Hashable, Equatable, Codable {
    public let account: String
    public let password: String

    public init(account: String, password: String) {
        self.password = password
        self.account = account
    }
}
