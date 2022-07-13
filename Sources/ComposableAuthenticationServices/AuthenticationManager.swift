public struct AuthenticationManager: Sendable {
    public let saveInternetPassword: @Sendable (_ password: String, _ server: String, _ account: String) throws -> Void
    public let deleteInternetPassword: @Sendable (_ server: String, _ account: Optional<String>) throws -> Void
    public let readInternetPassword: @Sendable (_ server: String, _ account: Optional<String>) throws -> (account: String, password: String)
}
