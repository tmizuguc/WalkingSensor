import Foundation

func unixtimeToDateString(unixtime: Int, short: Bool = false) -> String {
    let date = NSDate(timeIntervalSince1970: TimeInterval(unixtime))
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    if (short) {
        dateFormatter.timeStyle = .short
    } else {
        dateFormatter.timeStyle = .medium
    }
    return dateFormatter.string(from: date as Date)
}

func getTimeString(time: Int) -> String {
    let minutes = Int(floor(Double(time)/60))
    let seconds = Int(Double(time).truncatingRemainder(dividingBy: 60.0))
    var minutesString: String
    var secondsString: String
    if minutes < 10 {
        minutesString = String("0\(minutes)")
    } else {
        minutesString = String("\(minutes)")
    }
    if seconds < 10 {
        secondsString = String("0\(seconds)")
    } else {
        secondsString = String("\(seconds)")
    }
    return String("\(minutesString):\(secondsString)")
}
