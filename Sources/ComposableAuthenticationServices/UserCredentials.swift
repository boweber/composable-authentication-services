public struct UserCredentials: Sendable, Hashable, Equatable {
    public let password: String
    public let account: String
    
    public init(password: String, account: String) {
        self.password = password
        self.account = account
    }
}
