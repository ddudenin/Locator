//
//  MapPoint.swift
//  Locator
//
//  Created by Дмитрий Дуденин on 07.11.2021.
//

import RealmSwift
import MapKit

class MapPoint: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0

    override class func primaryKey() -> String? {
        return "id"
    }
}
