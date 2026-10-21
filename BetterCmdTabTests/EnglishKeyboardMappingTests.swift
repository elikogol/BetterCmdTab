import Carbon.HIToolbox
import Foundation
import Testing
@testable import BetterCmdTab

@Suite("English keyboard mapping")
@MainActor
struct EnglishKeyboardMappingTests {
    @Test("The option swaps both layout caches to US and restores them when off")
    func englishLayoutWhileEnabled() throws {
        let key = Preferences.Keys.alwaysUseEnglishKeyboard
        let raw = UserDefaults.standard.object(forKey: key)
        defer {
            if let raw { UserDefaults.standard.set(raw, forKey: key) }
            else { UserDefaults.standard.removeObject(forKey: key) }
            KeyboardLayout.reload()
        }
        UserDefaults.standard.removeObject(forKey: key)
        let activeLayout = KeyboardLayout.currentOrFallbackLayoutData()
        let english = try #require(KeyboardLayout.englishLayoutData())

        UserDefaults.standard.set(true, forKey: key)
        #expect(KeyboardLayout.currentOrFallbackLayoutData() == english)
        #expect(KeyboardLayout.asciiCapableLayoutData() == english)
        KeyboardLayout.reload()
        let keys: [(Int, Character)] = [
            (kVK_ANSI_Q, "q"), (kVK_ANSI_A, "a"), (kVK_ANSI_Z, "z"), (kVK_ANSI_M, "m"),
            (kVK_ANSI_Slash, "/"), (kVK_ANSI_Backslash, "\\"), (kVK_ANSI_1, "1"), (kVK_ANSI_Semicolon, ";"),
        ]
        for (keyCode, expected) in keys {
            #expect(KeyboardLayout.character(for: keyCode) == expected)
        }

        UserDefaults.standard.set(false, forKey: key)
        #expect(KeyboardLayout.currentOrFallbackLayoutData() == activeLayout)
    }
}
