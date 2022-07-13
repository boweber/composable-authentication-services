import ComposableAuthenticationServices
import ComposableArchitecture
import XCTest

class ComposableAuthenticationServicesTests: XCTestCase {
    
    func testLiveSavingInternetPassword() {
        let store = TestStore(
            initialState: AuthenticationManager.State(),
            reducer: .authenticate,
            environment: AuthenticationManager.live
        )
        let credentials = UserCredentials(account: "account", password: "password")
        let server = "server.com"
        store.send(
            .saveInternetPassword(server: server, credentials: credentials)
        ) {
            $0.savedInternetPassword = .success(true)
        }
        
        store.send(.readInternetPassword(server: server, account: credentials.account)) {
            $0.readInternetPassword = .success(.init(account: credentials.account, password: credentials.password))
        }
        
        store.send(.deleteInternetPassword(server: server, account: credentials.account)) {
            $0.deletedInternetPassword = .success(true)
        }
      }
    
    func testLiveUpdatingInternetPassword() {
        let store = TestStore(
            initialState: AuthenticationManager.State(),
            reducer: .authenticate,
            environment: AuthenticationManager.live
        )
        let credentials = UserCredentials(account: "account", password: "password")
        let server = "server.com"
        store.send(
            .saveInternetPassword(server: server, credentials: credentials)
        ) {
            $0.savedInternetPassword = .success(true)
        }
        
        store.send(.readInternetPassword(server: server, account: credentials.account)) {
            $0.readInternetPassword = .success(.init(account: credentials.account, password: credentials.password))
        }
        
        let newCredentials = UserCredentials(account: "account", password: "new-password")
        
        store.send(
            .saveInternetPassword(server: server, credentials: newCredentials)
        )
        
        store.send(.readInternetPassword(server: server, account: credentials.account)) {
            $0.readInternetPassword = .success(.init(account: newCredentials.account, password: newCredentials.password))
        }
        
        store.send(.deleteInternetPassword(server: server, account: newCredentials.account)) {
            $0.deletedInternetPassword = .success(true)
        }
      }
    
    func testFailSavingInternetPassword() {
        let store = TestStore(
            initialState: AuthenticationManager.State(),
            reducer: .authenticate,
            environment: AuthenticationManager.throwError(.failedToEncodeString)
        )
        
        store.send(.saveInternetPassword(server: "", account: "", password: "")) {
            $0.savedInternetPassword = .failure(.failedToEncodeString)
        }
    }
    
    func testFailDeletingInternetPassword() {
        let store = TestStore(
            initialState: AuthenticationManager.State(),
            reducer: .authenticate,
            environment: AuthenticationManager.throwError(.noPassword)
        )
        
        store.send(.deleteInternetPassword(server: "", account: "")) {
            $0.deletedInternetPassword = .failure(.noPassword)
        }
    }
    
    func testFailReadingInternetPassword() {
        let store = TestStore(
            initialState: AuthenticationManager.State(),
            reducer: .authenticate,
            environment: AuthenticationManager.throwError(.unexpectedPasswordData)
        )
        
        store.send(.readInternetPassword(server: "", account: "")) {
            $0.readInternetPassword = .failure(.unexpectedPasswordData)
        }
    }
    
    func testReadItemNotFound() {
        let store = TestStore(
            initialState: AuthenticationManager.State(),
            reducer: .authenticate,
            environment: .live
        )
        
        store.send(.readInternetPassword(server: "", account: "")) {
            $0.readInternetPassword = .failure(.noPassword)
        }
    }
}
