#if DEBUG
import XCTestDynamicOverlay

extension AuthenticationManager {    
    public static func throwError(_ error: AuthenticationManager.Error) -> AuthenticationManager {
        AuthenticationManager { _, _, _ in
            throw error
        } deleteInternetPassword: { _, _ in
            throw error
        } readInternetPassword: { _, _ in
            throw error
        }
    }
    
    public static func unsafeReturn(
        userCredentials: Optional<UserCredentials> = nil
    ) -> AuthenticationManager {
        AuthenticationManager { _, _, _ in
        } deleteInternetPassword: { _, _ in
        } readInternetPassword: { _, _ in
            if let userCredentials {
                return (userCredentials.account, userCredentials.password)
            } else {
                fatalError("Failed to provied a default return type for user credentials")
            }
        }
    }
}
#endif
