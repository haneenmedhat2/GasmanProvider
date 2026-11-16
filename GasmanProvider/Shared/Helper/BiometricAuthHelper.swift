//
//  BiometricAuthHelper.swift
//  GasmanProvider
//
import LocalAuthentication

struct BiometricAuthHelper {

    enum BiometricType {
        case faceID
        case touchID
        case none
    }

    static var biometricType: BiometricType {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .faceID:  return .faceID
        case .touchID: return .touchID
        default:       return .none
        }
    }

    static func authenticate(
        reason: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {

        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(
            .deviceOwnerAuthentication,
            error: &error
        ) else {

            DispatchQueue.main.async {
                completion(false, error)
            }
            return
        }

        context.evaluatePolicy(
            .deviceOwnerAuthentication,
            localizedReason: reason
        ) { success, authError in

            DispatchQueue.main.async {
                completion(success, authError)
            }
        }
    }
}

