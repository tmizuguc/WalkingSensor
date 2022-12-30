//
//  History+CoreDataProperties.swift
//  walking_sensor
//
//  Created by Tatsuya Mizuguchi on 2022/12/30.
//
//

import Foundation
import CoreData


extension History {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<History> {
        return NSFetchRequest<History>(entityName: "History")
    }

    @NSManaged public var id: Int32
    @NSManaged public var user_uuid: String?
    @NSManaged public var device_uuid: String?
    @NSManaged public var exam_type_id: Int32
    @NSManaged public var start_unixtime: Int32
    @NSManaged public var end_unixtime: Int32
    @NSManaged public var pedometer_id: Int32
    @NSManaged public var motion_sensor_id: Int32

}

extension History : Identifiable {

}
