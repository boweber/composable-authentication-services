#if DEBUG
import XCTestDynamicOverlay

extension AuthenticationManager {

    public static let failing = AuthenticationManager(
        saveInternetPassword: XCTUnimplemented("\(Self.self).saveInternetPassword"),
        deleteInternetPassword: XCTUnimplemented("\(Self.self).deleteInternetPassword"),
        readInternetPassword: XCTUnimplemented("\(Self.self).readInternetPassword")
    )
    
    public static func throwError(_ error: AuthenticationManager.Error) -> AuthenticationManager {
        AuthenticationManager { _, _, _ in
            throw error
        } deleteInternetPassword: { _, _ in
            throw error
        } readInternetPassword: { _, _ in
            throw error
        }
    }
}
#endif
