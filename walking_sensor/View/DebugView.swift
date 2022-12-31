import SwiftUI
import CoreData

struct DebugView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var pedometers: FetchedResults<Pedometer>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id)])
    var histories: FetchedResults<History>
    
    @ObservedObject var motionRecordManager = MotionRecordManager()
    
    @State private var userId: String = "User1"
    let deviceId: String = UIDevice.current.identifierForVendor!.uuidString
    @State private var examTypeId: Int = 0
        
    var body: some View {

        Spacer()
        
        HStack {
            Text("UserId")
            TextField("userId", text: $userId)
        }
        HStack {
            Text("ExamTypeId")
            TextField("ExamTypeId", value: $examTypeId, formatter: NumberFormatter())
        }
        
        
        HStack(spacing: 20){
            Button(action: { motionRecordManager.start(motionInterval: 0.1) } ){ Text("Start") }
            Button(action: { motionRecordManager.stop() } ){ Text("Stop") }
            Button(action: {
                motionRecordManager.finish(
                    context: context, user_id: userId, device_id: deviceId,
                    exam_id: getNextExamId(), exam_type_id: examTypeId)
            } ){ Text("Finish") }
        }.buttonStyle(.bordered).padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
    
        
        List {
            Text("START: \(String(motionRecordManager.isStarted)) step")
            Text("経過時間: \(String(format: "%.2f", motionRecordManager.pedometerData?.period ?? 0)) s")
            Text("歩数: \(motionRecordManager.pedometerData?.steps ?? 0) step")
            Text("歩行速度: \(String(format: "%.2f", motionRecordManager.pedometerData?.speed ?? 0)) m/s")
            Text("歩幅: \(String(format: "%.2f", motionRecordManager.pedometerData?.stride ?? 0)) m/step")
            Text("歩行距離: \(String(format: "%.2f", motionRecordManager.pedometerData?.distance ?? 0)) m")
        }
        
        List {
            ForEach(pedometers) { pedometer in
                Text("\(pedometer.exam_id): \(pedometer.steps) 歩, \(pedometer.distance) m")
            }
            Text("センサー数: \(motionSensors.count)")
        }
        
        List {
            ForEach(histories) { history in
                Text("\(history.exam_id): \(unixtimeToDateString(unixtime: Int(history.start_unixtime))) ~ \(unixtimeToDateString(unixtime: Int(history.end_unixtime)))")
            }
            .onDelete(perform: deleteHistory)
        }
    }

    
    func getNextExamId() -> Int {
        if (histories.count == 0) {
            return 1
        }
        return Int(histories[histories.count-1].exam_id) + 1
    }
    
    // Historyを削除し、それに紐づくMotionSensorとPedometerも削除する。
    func deleteHistory(offsets: IndexSet) {
        offsets.forEach { index in
            let exam_id = histories[index].exam_id
            context.delete(histories[index])
            for p_index in (pedometers.indices) {
                if (pedometers[p_index].exam_id == exam_id) {
                    context.delete(pedometers[p_index])
                }
            }
            for m_index in (motionSensors.indices) {
                if (motionSensors[m_index].exam_id == exam_id) {
                    context.delete(motionSensors[m_index])
                }
            }
        }
        try? context.save()
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
