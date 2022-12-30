import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.unixtime)])
    var pedometers: FetchedResults<Pedometer>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.start_unixtime)])
    var histories: FetchedResults<History>
    
    @ObservedObject var motionManager = MotionManager()
    
    let user_id: String = "User1"
    let deviceId: String = UIDevice.current.identifierForVendor!.uuidString
    let exam_type_id = 2
        
    var body: some View {

        Spacer()
        
        HStack(spacing: 20){
            Button(action: {
                motionManager.start(motionInterval: 0.1)
                
            } ){ Text("Start") }
            Button(action: {
                motionManager.stop(
                    context: context, user_id: user_id, device_id: deviceId,
                    exam_id: getNextExamId(), exam_type_id: exam_type_id)
            } ){ Text("Stop") }
            Button(action: {
                motionManager.clearData()
            } ){ Text("Crear") }
        }.buttonStyle(.bordered).padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
    
        
        List {
            Text("START: \(String(motionManager.isStarted)) step")
            Text("経過時間: \(String(format: "%.2f", motionManager.pedometerData?.period ?? 0)) s")
            Text("歩数: \(motionManager.pedometerData?.steps ?? 0) step")
            Text("歩行速度: \(String(format: "%.2f", motionManager.pedometerData?.speed ?? 0)) m/s")
            Text("歩幅: \(String(format: "%.2f", motionManager.pedometerData?.stride ?? 0)) m/step")
            Text("歩行距離: \(String(format: "%.2f", motionManager.pedometerData?.distance ?? 0)) m")
        }
        
        List {
            ForEach(pedometers) { pedometer in
                Text("\(pedometer.exam_id): \(pedometer.steps) 歩, \(pedometer.distance) m")
            }
        }
        
        List {
            ForEach(histories) { history in
                Text("\(history.exam_id): \(history.start_unixtime) 歩, \(history.end_unixtime) m")
            }
        }
    }

    
    func getNextExamId() -> Int {
        if (histories.count == 0) {
            return 1
        }
        return Int(histories[histories.count-1].exam_id) + 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
