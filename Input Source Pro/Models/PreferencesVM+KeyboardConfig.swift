import AppKit
import Foundation
import SwiftUI

extension PreferencesVM {
    private var didMigrateModeAwareKeyboardConfigsKey: String {
        "didMigrateModeAwareKeyboardConfigs"
    }

    func addKeyboardConfig(_ inputSource: InputSource) -> KeyboardConfig {
        if let config = getKeyboardConfig(inputSource) {
            return config
        } else {
            let config = KeyboardConfig(context: container.viewContext)

            config.id = inputSource.persistentIdentifier

            saveContext()

            return config
        }
    }

    func update(_ config: KeyboardConfig, textColor: NSColor, bgColor: NSColor) {
        let defaultTextHex = preferences.indicatorForgegroundNSColor.normalizedRGBColor.hexWithAlpha
        let defaultBgHex = preferences.indicatorBackgroundNSColor.normalizedRGBColor.hexWithAlpha
        let textHex = textColor.normalizedRGBColor.hexWithAlpha
        let bgHex = bgColor.normalizedRGBColor.hexWithAlpha

        let nextTextHex = textHex == defaultTextHex ? nil : textHex
        let nextBgHex = bgHex == defaultBgHex ? nil : bgHex

        guard config.textColorHex != nextTextHex || config.bgColorHex != nextBgHex else { return }

        saveContext {
            config.textColorHex = nextTextHex
            config.bgColorHex = nextBgHex
        }
    }

    func getKeyboardConfig(_ inputSource: InputSource) -> KeyboardConfig? {
        return keyboardConfigs.first(where: { $0.id == inputSource.persistentIdentifier })
            ?? keyboardConfigs.first(where: { $0.id == inputSource.id })
    }

    func getOrCreateKeyboardConfig(_ inputSource: InputSource) -> KeyboardConfig {
        return getKeyboardConfig(inputSource) ?? addKeyboardConfig(inputSource)
    }

    func migrateKeyboardConfigIdentifiersIfNeed() {
        guard !UserDefaults.standard.bool(forKey: didMigrateModeAwareKeyboardConfigsKey) else { return }

        let request: NSFetchRequest<KeyboardConfig> = KeyboardConfig.fetchRequest()

        do {
            let configs = try container.viewContext.fetch(request)
            var existingIDs = Set(configs.compactMap(\.id))

            let didSave = saveContext {
                for config in configs {
                    guard let legacyID = config.id, !legacyID.isEmpty else { continue }
                    guard !InputSource.hasModeAwareIdentifier(legacyID) else { continue }

                    let inputSources = InputSource.resolvePersistedIdentifiers(
                        [legacyID],
                        expandingLegacySourceIDs: true
                    )

                    for inputSource in inputSources {
                        let targetID = inputSource.persistentIdentifier
                        guard targetID != legacyID, !existingIDs.contains(targetID) else { continue }

                        let migratedConfig = KeyboardConfig(context: self.container.viewContext)
                        migratedConfig.id = targetID
                        migratedConfig.textColorHex = config.textColorHex
                        migratedConfig.bgColorHex = config.bgColorHex
                        existingIDs.insert(targetID)
                    }
                }
            }

            if didSave {
                UserDefaults.standard.set(true, forKey: didMigrateModeAwareKeyboardConfigsKey)
            }
        } catch {
            print("migrateKeyboardConfigIdentifiers error: \(error.localizedDescription)")
        }
    }
}

extension PreferencesVM {
    func getTextNSColor(_ inputSource: InputSource) -> NSColor? {
        let isAutoAppearanceMode = preferences.isAutoAppearanceMode

        if let keyboardColor = getKeyboardConfig(inputSource)?.textNSColor {
            return keyboardColor
        } else {
            return isAutoAppearanceMode
                ? preferences.indicatorForgeground?.dynamicColor
                : preferences.indicatorForgegroundNSColor
        }
    }

    func getTextColor(_ inputSource: InputSource) -> Color {
        if let nsColor = getTextNSColor(inputSource) {
            return Color(nsColor)
        } else {
            return preferences.indicatorForgegroundColor
        }
    }

    func getBgNSColor(_ inputSource: InputSource) -> NSColor? {
        let isAutoAppearanceMode = preferences.isAutoAppearanceMode

        if let bgColor = getKeyboardConfig(inputSource)?.bgNSColor {
            return bgColor
        } else {
            return isAutoAppearanceMode
                ? preferences.indicatorBackground?.dynamicColor
                : preferences.indicatorBackgroundNSColor
        }
    }

    func getBgColor(_ inputSource: InputSource) -> Color {
        if let nsColor = getBgNSColor(inputSource) {
            return Color(nsColor)
        } else {
            return preferences.indicatorBackgroundColor
        }
    }
}

extension PreferencesVM {
    struct DeprecatedKeyboardSettings: Codable & Equatable & Identifiable {
        let id: String

        var textColorHex: String?
        var bgColorHex: String?
    }

    func migratePreferncesIfNeed() {
        update {
            $0.migrateCJKVFixStrategyIfNeed()
        }

        if preferences.prevInstalledBuildVersion <= 462 {
            let shouldShowInputSourcesLabel = UserDefaults.standard.object(
                forKey: "isShowInputSourcesLabel"
            ) as? Bool ?? true

            update {
                $0.indicatorInfo = shouldShowInputSourcesLabel ? .iconAndTitle : .iconOnly
            }
        }
    }

    func migrateLegacyKeyboardSettingsIfNeed() {
        let keyboardSettingsURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("KeyboardSettings")

        guard preferences.prevInstalledBuildVersion == 316,
              let storagePath = keyboardSettingsURL,
              FileManager.default.fileExists(atPath: storagePath.path) else { return }

        do {
            let data = try Data(contentsOf: storagePath)
            let items = try JSONDecoder().decode([DeprecatedKeyboardSettings].self, from: data)

            guard !items.isEmpty else { return }

            saveContext {
                for item in items {
                    let matchedInputSources = InputSource.resolvePersistedIdentifiers(
                        [item.id],
                        expandingLegacySourceIDs: true
                    )

                    for inputSource in matchedInputSources {
                        let config = self.getOrCreateKeyboardConfig(inputSource)
                        config.textColorHex = item.textColorHex
                        config.bgColorHex = item.bgColorHex
                    }
                }
            }

            try FileManager.default.removeItem(at: storagePath)
        } catch {
            print("Legacy keyboard settings migration error: \(error.localizedDescription)")
        }
    }
}
