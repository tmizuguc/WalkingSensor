import CoreMotion

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
        let steps: Int = pedometer.numberOfSteps.intValue
        let distance: Double = pedometer.distance?.doubleValue ?? 0
        let period: Double = pedometer.endDate.timeIntervalSince(pedometer.startDate)
        let avarage_active_pace: Double = pedometer.averageActivePace?.doubleValue ?? 0
        return PedometerData(
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
    func savePedometerData() {
        
    }
    
    /*
     Pedometerのpedometer_idの最大値を取得する
     */
    func getMaxPedmeterId() -> Int {
        return 1
    }
    
    /*
     Pedometerのpedometer_idの最大値を取得する
     */
    func getMaxSensorId() -> Int {
        return 1
    }
    
}
