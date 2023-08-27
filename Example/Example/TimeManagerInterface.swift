import Foundation
import Combine

typealias TimeManagerTimeUpdates = AsyncStream<Date>

protocol TimeManager: Actor {
    var startTime: Date { get }
    var currentTime: Date { get }
    var timeUpdates: TimeManagerTimeUpdates { get }
}
