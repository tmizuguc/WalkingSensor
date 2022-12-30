import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    
    @ObservedObject var motionManager = MotionManager()
        
    var body: some View {

        Spacer()
        
        HStack(spacing: 20){
            Button(action: { motionManager.start(motionInterval: 0.1) } ){ Text("Start") }
            Button(action: { motionManager.stop() } ){ Text("Stop") }
            Button(action: { motionManager.clearData() } ){ Text("Crear") }
        }.buttonStyle(.bordered).padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
    
        
        List {
            Text("経過時間: \(String(format: "%.2f", motionManager.pedometerData?.period ?? 0)) s")
            Text("歩数: \(motionManager.pedometerData?.steps ?? 0) step")
            Text("歩行速度: \(String(format: "%.2f", motionManager.pedometerData?.speed ?? 0)) m/s")
            Text("歩幅: \(String(format: "%.2f", motionManager.pedometerData?.stride ?? 0)) m/step")
            Text("歩行距離: \(String(format: "%.2f", motionManager.pedometerData?.distance ?? 0)) m")
        }
    }
    

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
