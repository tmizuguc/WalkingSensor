import SwiftUI

struct ResultSelectView: View {
    var body: some View {
        List {
            // 歩行エクササイズの結果画面
            NavigationLink {
                ResultListView(examTypeId: 0)
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("歩行エクササイズ")
                }
            }
            
            // 歩行機能検査の結果画面
            NavigationLink {
                ResultListView(examTypeId: 1)
            } label: {
                HStack {
                    Image(systemName: "pencil")
                    Text("歩行機能検査")
                }
            }
        }
    }
}
