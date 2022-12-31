import SwiftUI

struct ResultListView: View {
    @Environment(\.managedObjectContext) var context
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var pedometers: FetchedResults<Pedometer>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id), SortDescriptor(\.unixtime)])
    var motionSensors: FetchedResults<MotionSensor>
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.exam_id)])
    var histories: FetchedResults<History>
    
    let exam_type_id: Int
    
    var body: some View {
        List {
            ForEach(histories) { history in
                Group {
                    if history.exam_type_id == exam_type_id {
                        NavigationLink {
                            ResultView(
                                history: history,
                                pedometer: pedometers.filter{ $0.exam_id == history.exam_id }[0]
                            )
                        } label: {
                            Text(unixtimeToDateString(unixtime: Int(history.start_unixtime), short: true))
                            Image(systemName: "figure.walk")
                            Text("\(pedometers.filter{$0.exam_id == history.exam_id}[0].steps) 歩")
                        }
                    }
                }
            }.onDelete(perform: deleteHistory)
        }
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
