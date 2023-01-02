import SwiftUI
import AVFoundation

struct WalkingExamView: View {
    @Environment(\.managedObjectContext) var context
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let userId: String
    let examTypeId: Int
    let examSpeedTypeId: Int
    let meter: Int
    let motionInterval: Double = 0.1
    let deviceId: String = UIDevice.current.identifierForVendor!.uuidString
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
            if examSpeedTypeId == 0 {
                Text("最大速度歩行").font(.title)
            }
            if examSpeedTypeId == 1 {
                Text("快適速度歩行").font(.title)
            }
            Text("\(String(floor(motionRecordManager.pedometerData?.distance ?? 0))) M").font(.largeTitle)
            
            // 歩行が終了したら「最初から」と「保存」ボタンを表示する
            if motionRecordManager.pedometerData?.distance ?? 0 >= Double(meter) {
                  
                HStack {
                    Button(action: {
                        motionRecordManager.clear()
                        presentationMode.wrappedValue.dismiss()
                    } ){
                        Text("最初から")
                    }
                    .buttonStyle(.bordered)
                    
                    Button(action: {
                        motionRecordManager.finish(
                            context: context, user_id: userId, device_id: deviceId,
                            exam_id: getNextExamId(), exam_type_id: examTypeId)
                        isFinishButton = true
                    } ){
                        Text("保存")
                    }
                    .buttonStyle(.bordered)
                    .onAppear {
                        speechText(text: "検査を終了します")
                        motionRecordManager.stop()
                    }
                }
            }
        }
        .onAppear{
            speechText(text: "検査を開始します")
            motionRecordManager.start(motionInterval: motionInterval)
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
