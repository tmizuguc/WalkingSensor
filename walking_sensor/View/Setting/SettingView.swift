import SwiftUI

struct SettingView: View {
    @AppStorage(wrappedValue: "",  "age") private var age: String
    @AppStorage(wrappedValue: "",  "height") private var height: String
    @AppStorage(wrappedValue: "",  "weight") private var weight: String
    
    
    var body: some View {
        Text("登録情報の編集ができます。")
        List {
            HStack {
                Text("年齢")
                Spacer()
                TextField("年齢を入力してください", text: $age).keyboardType(.decimalPad)
            }
            
            HStack {
                Text("身長")
                Spacer()
                TextField("身長を入力してください", text: $height).keyboardType(.decimalPad)
            }
            
            HStack {
                Text("体重")
                Spacer()
                TextField("体重を入力してください", text: $weight).keyboardType(.decimalPad)
            }
        }
    }
}
