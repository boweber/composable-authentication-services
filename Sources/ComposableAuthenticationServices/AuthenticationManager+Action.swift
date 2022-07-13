extension AuthenticationManager {
    public enum Action: Sendable, Hashable, Equatable {
        case saveInternetPassword(password: String, server: String, account: String)
        case deleteInternetPassword(server: String, account: Optional<String>)
        case readInternetPassword(server: String, account: Optional<String>)
        
        public static func saveInternetPassword(server: String, credentials: UserCredentials) -> Action {
            .saveInternetPassword(password: credentials.password, server: server, account: credentials.account)
        }
    }
}
