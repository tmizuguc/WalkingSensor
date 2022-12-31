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
