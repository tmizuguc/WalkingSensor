import CoreMotion
import CoreData

class MotionRecordManager: NSObject, ObservableObject {
    
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
                    // 15,000データ（50Hzで5分）以上の場合は、古いものから削除していく
                    if (self.motionSensorDataList.count > 15000) {
                        self.motionSensorDataList.removeFirst()
                    }
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
    func stop() {
        if (!isStarted) {
            return
        }
        motionManager.stopDeviceMotionUpdates()
        pedometerManager.stopUpdates()
        isStarted = false
    }
    
    /*
     センサーの保存処理
     */
    func finish(context: NSManagedObjectContext, user_id: String, device_id: String, exam_id: Int, exam_type_id: Int) {
        if (isStarted) {
            return
        }
        if (motionSensorDataList.count >= 1 && pedometerData != nil) {
            end_unixtime = Int(NSDate().timeIntervalSince1970)
            // センサー情報
            for motionSensorData in motionSensorDataList {
                historyManager.saveMotionSensorData(
                    motionSensorData: motionSensorData, exam_id: exam_id,
                    context: context)
            }
            // 歩行情報
            historyManager.savePedometerData(
                pedometerData: pedometerData!, exam_id: exam_id,
                context: context)
            // テスト情報
            historyManager.saveHistoryData(
                user_id: user_id, device_id: device_id, exam_type_id: exam_type_id,
                exam_id: exam_id, start_unixtime: start_unixtime, end_unixtime: end_unixtime,
                context: context)
            // キャッシュリセット
            clear()
        }
    }
    
    /*
     キャッシュリセット
     */
    func clear() {
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
