//
//  Pedometer+CoreDataProperties.swift
//  walking_sensor
//
//  Created by Tatsuya Mizuguchi on 2022/12/30.
//
//

import Foundation
import CoreData


extension Pedometer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pedometer> {
        return NSFetchRequest<Pedometer>(entityName: "Pedometer")
    }

    @NSManaged public var id: Int32
    @NSManaged public var pedometer_id: Int32
    @NSManaged public var period: Double
    @NSManaged public var steps: Int32
    @NSManaged public var stride: Double
    @NSManaged public var speed: Double
    @NSManaged public var average_active_pace: Double
    @NSManaged public var distance: Double

}

extension Pedometer : Identifiable {

}
