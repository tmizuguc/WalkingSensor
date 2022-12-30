//
//  MotionSensor+CoreDataProperties.swift
//  walking_sensor
//
//  Created by Tatsuya Mizuguchi on 2022/12/30.
//
//

import Foundation
import CoreData


extension MotionSensor {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MotionSensor> {
        return NSFetchRequest<MotionSensor>(entityName: "MotionSensor")
    }

    @NSManaged public var id: Int32
    @NSManaged public var motion_sensor_id: Int32
    @NSManaged public var unixtime: Int32
    @NSManaged public var acceleration_x: Double
    @NSManaged public var acceleration_y: Double
    @NSManaged public var acceleration_z: Double
    @NSManaged public var rotation_x: Double
    @NSManaged public var rotation_y: Double
    @NSManaged public var rotation_z: Double
    @NSManaged public var gravity_x: Double
    @NSManaged public var gravity_y: Double
    @NSManaged public var gravity_z: Double
    @NSManaged public var pitch: Double
    @NSManaged public var yaw: Double
    @NSManaged public var roll: Double

}

extension MotionSensor : Identifiable {

}
