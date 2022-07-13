//
//  File.swift
//  
//
//  Created by Bo Weber on 13.07.22.
//

import ComposableArchitecture

extension Reducer where State == AuthenticationManager.State, Action == AuthenticationManager.Action, Environment == AuthenticationManager {
    public static let authenticate = Reducer { state, action, authenticationManager in
        switch action {
        case let .deleteInternetPassword(server: server, account: account):
            do {
                try authenticationManager.deleteInternetPassword(server, account)
                state.deletedInternetPassword = .success(true)
            } catch {
                if let error = error as? AuthenticationManager.Error {
                    state.deletedInternetPassword = .failure(error)
                } else {
                    fatalError("\(AuthenticationManager.self) threw unexpected error: \(error)")
                }
            }
        case let .readInternetPassword(server: server, account: account):
            do {
                let credentials = try authenticationManager.readInternetPassword(server, account)
                state.readInternetPassword = .success(AuthenticationManager.State.Credentials(password: credentials.password, account: credentials.account))
            } catch {
                if let error = error as? AuthenticationManager.Error {
                    state.readInternetPassword = .failure(error)
                } else {
                    fatalError("\(AuthenticationManager.self) threw unexpected error: \(error)")
                }
            }
        case let .saveInternetPassword(password: password, server: server, account: account):
            do {
                try authenticationManager.saveInternetPassword(password, server, account)
                state.savedInternetPassword = .success(true)
            } catch {
                if let error = error as? AuthenticationManager.Error {
                    state.savedInternetPassword = .failure(error)
                } else {
                    fatalError("\(AuthenticationManager.self) threw unexpected error: \(error)")
                }
            }
        }
        return .none
    }
}
extension Reducer {
    func authenticatable(
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
