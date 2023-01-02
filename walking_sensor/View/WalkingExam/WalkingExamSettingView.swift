import SwiftUI

struct WalkingExamSettingView: View {
    let userId: String
    let examTypeId: Int
    let examSpeedTypeId: Int
    @State private var meter = 10
    @State var isSelectedButton = false
    
    var body: some View {
        Group {
            if examSpeedTypeId == 0 {
                Text("最大速度歩行").font(.title)
                Spacer()
                Text("可能な限り速いペースで歩いてください。\n転倒には十分に留意してください。")
            }
            if examSpeedTypeId == 1 {
                Text("快適速度歩行").font(.title)
                Spacer()
                Text("いつも歩いているペースで歩いてください。")
            }
        }
        Form {
            Section {
                Picker(selection: $meter, label: Text("歩行距離")) {
                    Text("10 m").tag(10)
                    Text("20 m").tag(20)
                    Text("30 m").tag(30)
                    Text("40 m").tag(40)
                    Text("50 m").tag(50)
                }
                .pickerStyle(.automatic)
                
                Button {
                    isSelectedButton = true
                } label: {
                    Text("検査開始").bold()
                }
            }
        }
        
        NavigationLink(
            destination: WalkingExamView(
                userId: userId, examTypeId: examTypeId,
                examSpeedTypeId: examSpeedTypeId, meter: meter),
            isActive: $isSelectedButton) { EmptyView() }
    }
}
