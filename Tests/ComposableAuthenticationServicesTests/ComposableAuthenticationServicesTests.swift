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
        let credentials = AuthenticationManager.State.Credentials(password: "password", account: "account")
        let server = "server.com"
        store.send(
            .saveInternetPassword(password: credentials.password, server: server, account: credentials.account)
        ) {
            $0.savedInternetPassword = .success(true)
        }
        
        store.send(.readInternetPassword(server: server, account: credentials.account)) {
            $0.readInternetPassword = .success(.init(password: credentials.password, account: credentials.account))
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
        let credentials = AuthenticationManager.State.Credentials(password: "password", account: "account")
        let server = "server.com"
        store.send(
            .saveInternetPassword(password: credentials.password, server: server, account: credentials.account)
        ) {
            $0.savedInternetPassword = .success(true)
        }
        
        store.send(.readInternetPassword(server: server, account: credentials.account)) {
            $0.readInternetPassword = .success(.init(password: credentials.password, account: credentials.account))
        }
        
        let newCredentials = AuthenticationManager.State.Credentials(password: "new-password", account: "account")
        
        store.send(
            .saveInternetPassword(password: newCredentials.password, server: server, account: newCredentials.account)
        )
        
        store.send(.readInternetPassword(server: server, account: credentials.account)) {
            $0.readInternetPassword = .success(.init(password: newCredentials.password, account: newCredentials.account))
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
        
        store.send(.saveInternetPassword(password: "", server: "", account: "")) {
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
