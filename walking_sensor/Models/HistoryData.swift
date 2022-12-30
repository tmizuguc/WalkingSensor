import Foundation
import CoreMotion

struct HistoryData {
    var user_uuid: String
    var device_uuid: String
    var exam_type_id: NSNumber
    var start_unixtime: NSNumber
    var end_unixtime: NSNumber
    var pedometer_id: NSNumber
    var motion_sensor_id: NSNumber
}

struct PedometerData {
    var pedometer_id: NSNumber
    var period: NSNumber
    var steps: NSNumber
    var stride: NSNumber
    var speed: NSNumber
    var avarage_active_pace: NSNumber
    var distance: NSNumber
}

struct MotionSensorData {
    var motion_sensor_id: NSNumber
    var unixtime: NSNumber
    var acceleration_x: NSNumber
    var acceleration_y: NSNumber
    var acceleration_z: NSNumber
    var rotation_x: NSNumber
    var rotation_y: NSNumber
    var rotation_z: NSNumber
    var gravity_x: NSNumber
    var gravity_y: NSNumber
    var gravity_z: NSNumber
    var pitch: NSNumber
    var yaw: NSNumber
    var roll: NSNumber
}

class HistoryManager: NSObject, ObservableObject {
    let motionManager = CMMotionManager()
    let pedometer = CMPedometer()
    let queue = OperationQueue()
    
    var motionSensorDataList: [MotionSensorData] = []
    @Published var pedometerData: PedometerData? = nil
    var startDate: NSDate = NSDate()
    var endDate: NSDate = NSDate()
    @Published var isStarted: Bool = false
    
    func start(motionInterval: Double) {
        startDate = NSDate()
        // モーションデータのListen開始
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = motionInterval
            motionManager.startDeviceMotionUpdates(to: self.queue){
                (data: CMDeviceMotion?, error: Error?) in
                if (error == nil) {
                    let motionData = self.toMotionData(deviceMotion: data!)
                    self.motionSensorDataList.append(motionData)
                }
            }
        }
        // PedometerデータのListen開始
        if (CMPedometer.isStepCountingAvailable()) {
            pedometer.startUpdates(from: startDate as Date) {
                (data: CMPedometerData?, error: Error?) in
                if (error == nil) {
                    self.pedometerData = self.toPedometerData(pedometer: data!)
                }
            }
        }
        isStarted = true
    }
    
    func stop() {
        if (!isStarted) {
            return
        }
        motionManager.stopDeviceMotionUpdates()
        pedometer.stopUpdates()
        // 終了時のPedometerを明示的に取得
        endDate = NSDate()
        pedometer.queryPedometerData(from: startDate as Date, to: endDate as Date) {
            (data: CMPedometerData?, error: Error?) in
            if (error == nil) {
                // Published変数なのでmainスレッドで変更する必要あり
                DispatchQueue.main.async {
                    self.pedometerData = self.toPedometerData(pedometer: data!)
                }
            }
        }
        isStarted = false
    }
    
    private func toMotionData(deviceMotion: CMDeviceMotion) -> MotionSensorData {
        // TODO: DBから最新のmotion_sensor_idを取得し、+1する
        let motion_sensor_id: NSNumber = 1
        let unixtime: NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        return MotionSensorData(
            motion_sensor_id: motion_sensor_id, unixtime: unixtime,
            acceleration_x: NSNumber(value: deviceMotion.userAcceleration.x),
            acceleration_y: NSNumber(value: deviceMotion.userAcceleration.y),
            acceleration_z: NSNumber(value: deviceMotion.userAcceleration.z),
            rotation_x: NSNumber(value: deviceMotion.rotationRate.x),
            rotation_y: NSNumber(value: deviceMotion.rotationRate.y),
            rotation_z: NSNumber(value: deviceMotion.rotationRate.z),
            gravity_x: NSNumber(value: deviceMotion.gravity.x),
            gravity_y: NSNumber(value: deviceMotion.gravity.y),
            gravity_z: NSNumber(value: deviceMotion.gravity.z),
            pitch: NSNumber(value: deviceMotion.attitude.pitch),
            yaw: NSNumber(value: deviceMotion.attitude.yaw),
            roll: NSNumber(value: deviceMotion.attitude.roll))
    }
    
    private func toPedometerData(pedometer: CMPedometerData) -> PedometerData {
        // TODO: DBから最新のpedometer_idを取得し、+1する
        let pedometer_id: NSNumber = 1
        let steps: NSNumber = pedometer.numberOfSteps
        let distance: NSNumber = pedometer.distance ?? 0
        let period: NSNumber = NSNumber(value: pedometer.endDate.timeIntervalSince(pedometer.startDate))
        let avarage_active_pace: NSNumber = pedometer.averageActivePace ?? 0
        return PedometerData(
            pedometer_id: pedometer_id,
            period: period,
            steps: steps,
            stride: NSNumber(value: distance.doubleValue / steps.doubleValue),
            speed: NSNumber(value: distance.doubleValue / period.doubleValue),
            avarage_active_pace: avarage_active_pace,
            distance: distance)
    }
    
    func clearData() {
        if (isStarted) {
            return
        }
        motionSensorDataList = []
        pedometerData = nil
    }
    
    func getPedometerData() -> PedometerData? {
        return pedometerData
    }
}
