import SwiftUI
import AVFoundation

struct WalkingExerciseView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let userId: String
    let examTypeId: Int
    let minutes: Int
    let seconds: Int
    let motionInterval: Double = 0.1
    let deviceId: String = UIDevice.current.identifierForVendor!.uuidString
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var showAlert = false
    @State var currentTime: Int = -3 // カウントダウン分を引いている
    @State var isReturnButton = false
    @State var isFinishButton = false
    @ObservedObject var motionRecordManager = MotionRecordManager()
    
    let synthesizer = AVSpeechSynthesizer()
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id)])
    var histories: FetchedResults<History>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var pedometers: FetchedResults<Pedometer>
    
    var body: some View {
        
        Group {
            // 歩行開始前にカウントダウンをする
            if currentTime < 0 {
                Group {
                    Text("\(-1 * currentTime)").font(.largeTitle)
                }.onChange(of: currentTime) { _ in
                    speechText(text: "\(-1 * currentTime)")
                }.onAppear{
                    speechText(text: "\(-1 * currentTime)")
                }
            }
            
            if currentTime >= 0 {
                Group {
                    Text("歩行エクササイズ").font(.title)
                    Text("\(getTimeString(time: currentTime))").font(.largeTitle)
                    Text("\(String(floor(motionRecordManager.pedometerData?.distance ?? 0))) M").font(.largeTitle)
                    
                }.onAppear{
                    speechText(text: "エクササイズを開始します")
                    motionRecordManager.start(motionInterval: motionInterval)
                }
            }
            
            // 歩行が終了したら「最初から」と「保存」ボタンを表示する
            if currentTime >= (minutes*60+seconds) {
                
                HStack {
                    Button(action: {
                        motionRecordManager.clear()
                        presentationMode.wrappedValue.dismiss()
                    } ){
                        Text("データを削除")
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        if motionRecordManager.pedometerData == nil {
                            showAlert = true
                        } else {
                            motionRecordManager.finish(
                                context: context, user_id: userId, device_id: deviceId,
                                exam_id: getNextExamId(), exam_type_id: examTypeId)
                            isFinishButton = true
                        }
                    } ){
                        Text("保存")
                    }
                    .buttonStyle(.bordered)
                    .onAppear {
                        speechText(text: "エクササイズを終了します")
                        motionRecordManager.stop()
                    }
                    .alert("歩行データがありません", isPresented: $showAlert) {
                        Button("OK") { /* Do Nothing */}
                    } message: {
                        Text("歩行データを取得できませんでした。再度やりなおしてください。")
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            currentTime += 1
            if currentTime >= (minutes*60+seconds) {
                timer.upstream.connect().cancel()
            }
        }
        
        NavigationLink(
            destination: ResultView(
                history: histories[histories.count - 1],
                pedometer: pedometers[pedometers.count - 1],
                showFinishButton: true),
            isActive: $isFinishButton) { EmptyView() }
    }
    
    func getNextExamId() -> Int {
        if (histories.count == 0) {
            return 1
        }
        return Int(histories[histories.count-1].exam_id) + 1
    }
    
    func speechText(text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        utterance.rate = 0.5
        self.synthesizer.speak(utterance)
    }
    
}
