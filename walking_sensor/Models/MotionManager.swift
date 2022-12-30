import CoreMotion


class MotionManager: NSObject, ObservableObject {
    
    let motionManager = CMMotionManager()
    let pedometer = CMPedometer()
    let queue = OperationQueue()
    
    let hisotryManager = HistoryManager()
    var motionSensorDataList: [MotionSensorData] = []
    @Published var pedometerData: PedometerData? = nil
    
    func start(motionInterval: Double) {

        // モーションデータのListen開始
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = motionInterval
            motionManager.startDeviceMotionUpdates(to: self.queue){
                (data: CMDeviceMotion?, error: Error?) in
                if (error == nil) {
                    let motionData = self.hisotryManager.toMotionSensorData(deviceMotion: data!)
                    self.motionSensorDataList.append(motionData)
                }
            }
        }
        // PedometerデータのListen開始
        if (CMPedometer.isStepCountingAvailable()) {
            pedometer.startUpdates(from: NSDate() as Date) {
                (data: CMPedometerData?, error: Error?) in
                if (error == nil) {
                    self.pedometerData = self.hisotryManager.toPedometerData(pedometer: data!)
                }
            }
        }
    }
    
    func stop() {
        motionManager.stopDeviceMotionUpdates()
        pedometer.stopUpdates()
    }
    
    func clearData() {
        motionSensorDataList = []
        pedometerData = nil
    }
    
    func getCurrentPedometerData() -> PedometerData? {
        return pedometerData
    }
}
