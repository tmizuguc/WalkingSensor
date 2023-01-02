import SwiftUI
import CoreData

struct HomeView: View {
    let userId: String = "User_A"
    var body: some View {
        List {
            // 歩行エクササイズ画面
            NavigationLink {
                WalkingExerciseSettingView(userId: userId, examTypeId: 0)
            } label: {
                HStack {
                    Image(systemName: "figure.walk")
                    Text("歩行エクササイズ")
                }
            }

            // 歩行機能検査画面
            NavigationLink {
                WalkingExamSelectView(userId: userId, examTypeId: 1)
            } label: {
                HStack {
                    Image(systemName: "figure.walk")
                    Text("歩行機能検査")
                }
            }

            // 結果一覧表示画面
            NavigationLink {
                ResultSelectView()
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("結果表示")
                }
            }

            // デバッグ画面
            NavigationLink {
                DebugView()
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("デバッグ")
                }
            }.foregroundColor(.gray)
        }.navigationBarTitle(Text("ホーム"))
    }
}
struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
