extension AuthenticationManager {
    public struct State: Sendable, Hashable, Equatable {
        public var savedInternetPassword: Optional<Result<Bool, AuthenticationManager.Error>>
        public var deletedInternetPassword: Optional<Result<Bool, AuthenticationManager.Error>>
        public var readInternetPassword: Optional<Result<UserCredentials, AuthenticationManager.Error>>
        
        public init(
            savedInternetPassword: Optional<Result<Bool, AuthenticationManager.Error>> = nil,
            deletedInternetPassword: Optional<Result<Bool, AuthenticationManager.Error>> = nil,
            readInternetPassword: Optional<Result<UserCredentials, AuthenticationManager.Error>> = nil
        ) {
            self.savedInternetPassword = savedInternetPassword
            self.deletedInternetPassword = deletedInternetPassword
            self.readInternetPassword = readInternetPassword
        }
    }
}
