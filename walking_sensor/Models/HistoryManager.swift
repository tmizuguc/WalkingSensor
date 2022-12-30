import CoreMotion
import CoreData

struct HistoryData {
    var user_uuid: String
    var device_uuid: String
    var exam_type_id: Int
    var start_unixtime: Int
    var end_unixtime: Int
    var pedometer_id: Int
    var motion_sensor_id: Int
}

struct PedometerData {
    var unixtime: Int
    var period: Double
    var steps: Int
    var stride: Double
    var speed: Double
    var average_active_pace: Double
    var distance: Double
}

struct MotionSensorData {
    var unixtime: Int
    var acceleration_x: Double
    var acceleration_y: Double
    var acceleration_z: Double
    var rotation_x: Double
    var rotation_y: Double
    var rotation_z: Double
    var gravity_x: Double
    var gravity_y: Double
    var gravity_z: Double
    var pitch: Double
    var yaw: Double
    var roll: Double
}


class HistoryManager: NSObject, ObservableObject {
    
    /*
     CMDeviceMotionからMotionDataへ変換する
     */
    func toMotionSensorData(deviceMotion: CMDeviceMotion) -> MotionSensorData {
        let unixtime: Int = Int(NSDate().timeIntervalSince1970)
        return MotionSensorData(
            unixtime: unixtime,
            acceleration_x: deviceMotion.userAcceleration.x,
            acceleration_y: deviceMotion.userAcceleration.y,
            acceleration_z: deviceMotion.userAcceleration.z,
            rotation_x: deviceMotion.rotationRate.x,
            rotation_y: deviceMotion.rotationRate.y,
            rotation_z: deviceMotion.rotationRate.z,
            gravity_x: deviceMotion.gravity.x,
            gravity_y: deviceMotion.gravity.y,
            gravity_z: deviceMotion.gravity.z,
            pitch: deviceMotion.attitude.pitch,
            yaw: deviceMotion.attitude.yaw,
            roll: deviceMotion.attitude.roll)
    }
    
    /*
     CMPedometerDataからPedometerDataへ変換する
     */
    func toPedometerData(pedometer: CMPedometerData) -> PedometerData {
        let unixtime: Int = Int(NSDate().timeIntervalSince1970)
        let steps: Int = pedometer.numberOfSteps.intValue
        let distance: Double = pedometer.distance?.doubleValue ?? 0
        let period: Double = pedometer.endDate.timeIntervalSince(pedometer.startDate)
        let avarage_active_pace: Double = pedometer.averageActivePace?.doubleValue ?? 0
        return PedometerData(
            unixtime: unixtime,
            period: period,
            steps: steps,
            stride: distance / Double(steps),
            speed: distance / period,
            average_active_pace: avarage_active_pace,
            distance: distance)
    }
    
    /*
     MotionSensorDataをSQLiteのPedometerに格納する
     */
    func saveMotionSensorData() {
        
    }
    
    /*
     PedometerDataをSQLiteのPedometerに格納する
     */
    func savePedometerData(pedometerData: PedometerData, exam_id: Int, context: NSManagedObjectContext) {
        let pedometer = Pedometer(context: context)
        pedometer.exam_id = Int32(exam_id)
        pedometer.unixtime = Int32(pedometerData.unixtime)
        pedometer.period = pedometerData.period
        pedometer.steps = Int32(pedometerData.steps)
        pedometer.stride = pedometerData.stride
        pedometer.speed = pedometerData.speed
        pedometer.average_active_pace = pedometerData.average_active_pace
        pedometer.distance = pedometerData.distance
        try? context.save()
    }
    
    /*
     SQLiteのHistoryに格納する
     */
    func saveHistoryData(user_id: String, device_id: String,
                         exam_type_id: Int, exam_id: Int,
                         start_unixtime: Int, end_unixtime:Int,
                         context: NSManagedObjectContext) {
        let history = History(context: context)
        history.user_uuid = user_id
        history.device_uuid = device_id
        history.exam_type_id = Int32(exam_type_id)
        history.exam_id = Int32(exam_id)
        history.start_unixtime = Int32(start_unixtime)
        history.end_unixtime = Int32(end_unixtime)
        try? context.save()
    }
    
}
