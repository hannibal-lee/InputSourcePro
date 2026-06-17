import Foundation

@propertyWrapper
struct CodableUserDefault<T: Codable> {
    var wrappedValue: T? {
        get {
            guard let data = userDefaults.data(forKey: key) else { return nil }
            return try? JSONDecoder().decode(T.self, from: data)
        }

        set {
            guard let newValue = newValue else {
                userDefaults.removeObject(forKey: key)
                return
            }

            do {
                let data = try JSONEncoder().encode(newValue)

                userDefaults.set(data, forKey: key)
            } catch {
                print("Unable to Encode (\(error))")
            }
        }
    }

    private let key: String
    private let userDefaults: UserDefaults

    init(_ key: String, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }

    init(wrappedValue defaultValue: T, _ key: String, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults

        do {
            try userDefaults.register(defaults: [key: JSONEncoder().encode(defaultValue)])
        } catch {
            print("Unable to register (\(error))")
        }
    }
}
