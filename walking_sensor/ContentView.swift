import SwiftUI

struct ContentView: View {
    @ObservedObject var historyManager = HistoryManager()
    @State var pedometerData: PedometerData? = nil
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        
    var body: some View {

        Spacer()
        
        HStack(spacing: 20){
            Button(action: { historyManager.start(motionInterval: 0.1) } ){ Text("Start") }
            Button(action: { historyManager.stop() } ){ Text("Stop") }
            Button(action: { historyManager.clearData() } ){ Text("Crear") }
        }.buttonStyle(.bordered).padding(EdgeInsets(top: 30, leading: 0, bottom: 0, trailing: 0))
    
        
        List {
            Text("start \(String(historyManager.isStarted))")
            Text("経過時間: \(String(format: "%.2f", pedometerData?.period.doubleValue ?? 0)) s")
            Text("歩数: \(pedometerData?.steps ?? 0) step")
            Text("歩行速度: \(String(format: "%.2f", pedometerData?.speed.doubleValue ?? 0)) m/s")
            Text("歩幅: \(String(format: "%.2f", pedometerData?.stride.doubleValue ?? 0)) m/step")
            Text("歩行距離: \(String(format: "%.2f", pedometerData?.distance.doubleValue ?? 0)) m")
        }.onReceive(timer) { _ in
            pedometerData = historyManager.getPedometerData()
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
