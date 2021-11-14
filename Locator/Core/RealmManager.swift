//
//  RealmManager.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 07.11.2021.
//

import RealmSwift

final class RealmManager {
    static let shared = RealmManager()

    private let realm: Realm

    private init?() {
        let config = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)

        guard let realm = try? Realm(configuration: config) else { return nil }

        self.realm = realm

#if DEBUG
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm Error")
#endif
    }

    func add<T: Object>(object: T) throws {
        try realm.write {
            realm.add(object)
        }
    }

    func add<T: Object>(objects: [T]) throws {
        try realm.write {
            realm.add(objects, update: .all)
        }
    }

    func getObjects<T: Object>() -> Results<T> {
        return realm.objects(T.self)
    }

    func delete<T: Object>(object: T) throws {
        try realm.write {
            realm.delete(object)
        }
    }

    func deleteAll() throws {
        try realm.write {
            realm.deleteAll()
        }
    }
}
