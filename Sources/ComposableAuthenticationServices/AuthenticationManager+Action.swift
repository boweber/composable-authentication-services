extension AuthenticationManager {
    public enum Action: Sendable, Hashable, Equatable {
        case saveInternetPassword(server: String, account: String, password: String)
        case deleteInternetPassword(server: String, account: Optional<String>)
        case readInternetPassword(server: String, account: Optional<String>)
        
        public static func saveInternetPassword(server: String, credentials: UserCredentials) -> Action {
            .saveInternetPassword(server: server, account: credentials.account, password: credentials.password)
        }
    }
}
