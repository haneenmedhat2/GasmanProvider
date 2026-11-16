//
//  KeychainHelper.swift
//  GasmanProvider
//

import Security
import Foundation

struct KeychainHelper {

    private static let service     = Bundle.main.bundleIdentifier ?? "com.gasman.provider"
    private static let phoneKey    = "biometric_phone"
    private static let passwordKey = "biometric_password"

    static func saveCredentials(phone: String, password: String) {
        save(key: phoneKey,    value: phone)
        save(key: passwordKey, value: password)
    }

    static func loadCredentials() -> (phone: String, password: String)? {
        guard let phone    = load(key: phoneKey),
              let password = load(key: passwordKey) else { return nil }
        return (phone, password)
    }

    static func deleteCredentials() {
        delete(key: phoneKey)
        delete(key: passwordKey)
    }

    // MARK: - Private

    private static func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else { return }
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        SecItemDelete(query as CFDictionary)
        var newItem = query
        newItem[kSecValueData] = data
        SecItemAdd(newItem as CFDictionary, nil)
    }

    private static func load(key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass:        kSecClassGenericPassword,
            kSecAttrService:  service,
            kSecAttrAccount:  key,
            kSecReturnData:   true,
            kSecMatchLimit:   kSecMatchLimitOne
        ]
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private static func delete(key: String) {
        let query: [CFString: Any] = [
            kSecClass:       kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
