import SwiftUI
import SwiftUICharts

struct ResultView: View {
    let history: History
    let pedometer: Pedometer
    
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
                Text("\(String(format: "%.0f", pedometer.period)) 秒")
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
                Text("1分あたり \(String(format: "%.1f", pedometer.speed)) メートル")
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
        }
        
        
    }
}
