import SwiftUI

struct WalkingExerciseSettingView: View {
    let userId: String
    let examTypeId: Int
    @State private var minutes = 2
    @State private var seconds = 0
    @State var isSelectedButton = false
    @State var showAlert = false
    
    var body: some View {
        Text("歩行エクササイズ").font(.title)
        Spacer()
        Text("転倒には十分に留意してください。")
        
        Form {
            Section {
                Picker(selection: $minutes, label: Text("時間（分）")) {
                    ForEach(0...60, id: \.self) {
                        Text("\($0) 分").tag($0)
                    }
                }
                .pickerStyle(.automatic)
                
                Picker(selection: $seconds, label: Text("時間（秒）")) {
                    ForEach(0...5, id: \.self) {
                        Text("\($0)0 秒").tag($0*10)
                    }
                }
                .pickerStyle(.automatic)
                
                Button {
                    if minutes == 0 && seconds == 0 {
                        showAlert = true
                    } else {
                        isSelectedButton = true
                    }
                } label: {
                    Text("検査開始").bold()
                }
                .alert("時間が0秒です", isPresented: $showAlert) {
                    Button("OK") { /* Do Nothing */}
                } message: {
                    Text("0分0秒以上を選択してください。")
                }
            }
        }
        
        NavigationLink(
            destination: WalkingExerciseView(
                userId: userId, examTypeId: examTypeId,
                minutes: minutes, seconds: seconds),
            isActive: $isSelectedButton) { EmptyView() }
    }
}

import SwiftUI

struct WalkingExamSettingsView: View {
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
