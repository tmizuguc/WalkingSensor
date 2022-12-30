import CoreMotion
import CoreData

class MotionManager: NSObject, ObservableObject {
    
    let motionManager = CMMotionManager()
    let pedometerManager = CMPedometer()
    let queue = OperationQueue()
    
    let historyManager = HistoryManager()
    var motionSensorDataList: [MotionSensorData] = []
    @Published var pedometerData: PedometerData? = nil
    
    var start_unixtime: Int = 0
    var end_unixtime: Int = 0
    @Published var isStarted: Bool = false
    
    /*
     センサー取得開始処理
     */
    func start(motionInterval: Double) {
        if (isStarted) {
            return
        }
        // モーションデータのListen開始
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = motionInterval
            motionManager.startDeviceMotionUpdates(to: self.queue){
                (data: CMDeviceMotion?, error: Error?) in
                if (error == nil) {
                    let motionData = self.historyManager.toMotionSensorData(deviceMotion: data!)
                    self.motionSensorDataList.append(motionData)
                }
            }
        }
        // PedometerデータのListen開始
        if (CMPedometer.isStepCountingAvailable()) {
            pedometerManager.startUpdates(from: NSDate() as Date) {
                (data: CMPedometerData?, error: Error?) in
                if (error == nil) {
                    self.pedometerData = self.historyManager.toPedometerData(pedometer: data!)
                }
            }
        }
        isStarted = true
        start_unixtime = Int(NSDate().timeIntervalSince1970)
    }
    
    /*
     センサー取得終了処理
     */
    func stop(context: NSManagedObjectContext, user_id: String, device_id: String, exam_id: Int, exam_type_id: Int) {
        if (!isStarted) {
            return
        }
        motionManager.stopDeviceMotionUpdates()
        pedometerManager.stopUpdates()
        
        // 各種データの保存
        if (motionSensorDataList.count >= 1 && pedometerData != nil) {
            end_unixtime = Int(NSDate().timeIntervalSince1970)
            
            historyManager.saveMotionSensorData()
            historyManager.savePedometerData(
                pedometerData: pedometerData!, exam_id: exam_id,
                context: context)
            historyManager.saveHistoryData(
                user_id: user_id, device_id: device_id, exam_type_id: exam_type_id,
                exam_id: exam_id, start_unixtime: start_unixtime, end_unixtime: end_unixtime,
                context: context)
        }
        isStarted = false
    }
    
    /*
     センサーのキャッシュ削除処理
     */
    func clearData() {
        if (isStarted) {
            return
        }
        motionSensorDataList = []
        pedometerData = nil
    }
    
    /*
     最新のPedometerデータを取得
     */
    func getCurrentPedometerData() -> PedometerData? {
        return pedometerData
    }
}
