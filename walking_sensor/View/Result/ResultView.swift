import SwiftUI
import SwiftUICharts

struct ResultView: View {
    let history: History
    let pedometer: Pedometer
    var showFinishButton: Bool = false
    @State var isFinishButton = false
    
    var body: some View {
        
        List {
            HStack {
                Text("開始時間")
                Spacer()
                Text(unixtimeToDateString(unixtime: Int(history.start_unixtime)))
            }
            
            HStack {
                Text("終了時間")
                Spacer()
                Text(unixtimeToDateString(unixtime: Int(history.end_unixtime)))
            }
            
            HStack {
                Text("エクササイズ時間")
                Spacer()
                Text("\(Int(floor(Double(history.end_unixtime) - Double(history.start_unixtime)))) 秒")
            }
            
            HStack {
                Text("歩数")
                Spacer()
                Text("\(pedometer.steps) 歩")
            }
            
            HStack {
                Text("歩行率")
                Spacer()
                let step_rate = 60 * Double(pedometer.steps) / pedometer.period
                Text("1分あたり \(String(format: "%.1f", step_rate)) 歩")
            }
            
            HStack {
                Text("歩行速度")
                Spacer()
                let speed = 60 * pedometer.speed
                Text("1分あたり \(String(format: "%.1f", speed)) メートル")
            }
            
            HStack {
                Text("歩幅")
                Spacer()
                Text("\(String(format: "%.1f", pedometer.stride)) メートル")
            }
            
            HStack {
                Text("歩行距離")
                Spacer()
                Text("\(String(format: "%.1f", pedometer.distance)) メートル")
            }
            
            if showFinishButton {
                Button(action: {
                    isFinishButton = true
                } ){
                    Text("ホームに戻る").bold()
                }
            }
        }
        
        NavigationLink(
            destination: HomeView(),
            isActive: $isFinishButton) { EmptyView() }
    }
}
