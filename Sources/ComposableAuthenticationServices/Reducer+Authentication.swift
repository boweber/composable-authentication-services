import ComposableArchitecture

extension Reducer where State == AuthenticationManager.State, Action == AuthenticationManager.Action, Environment == AuthenticationManager {
    public static let authenticate = Reducer { state, action, authenticationManager in
        switch action {
        case let .deleteInternetPassword(server: server, account: account):
            do {
                try authenticationManager.deleteInternetPassword(server, account)
                state.deletedInternetPassword = .success(true)
            } catch {
                state.unsafeAssign(error, to: \.deletedInternetPassword)
            }
        case let .readInternetPassword(server: server, account: account):
            do {
                let credentials = try authenticationManager.readInternetPassword(server, account)
                state.readInternetPassword = .success(UserCredentials(account: credentials.account, password: credentials.password))
            } catch {
                state.unsafeAssign(error, to: \.readInternetPassword)
            }
        case let .saveInternetPassword(server: server, account: account, password: password):
            do {
                try authenticationManager.saveInternetPassword(server, account, password)
                state.savedInternetPassword = .success(true)
            } catch {
                state.unsafeAssign(error, to: \.savedInternetPassword)
            }
        }
        return .none
    }
}

extension Reducer {
    public func authenticatable(
        state: WritableKeyPath<State, AuthenticationManager.State>,
        action: CasePath<Action, AuthenticationManager.Action>,
        environment: @escaping (Environment) -> AuthenticationManager
    ) -> Self {
        .combine(
            Reducer<AuthenticationManager.State, AuthenticationManager.Action, AuthenticationManager>
                .authenticate
                .pullback(state: state, action: action, environment: environment),
            self
        )
    }
}

private extension AuthenticationManager.State {
    mutating func unsafeAssign<Success>(
        _ error: Error,
        to keypath: WritableKeyPath<Self, Optional<Result<Success, AuthenticationManager.Error>>>
    ) {
        if let error = error as? AuthenticationManager.Error {
            self[keyPath: keypath] = .failure(error)
        } else {
            fatalError("\(AuthenticationManager.self) threw unexpectedly \(error)")
        }
    }
}
