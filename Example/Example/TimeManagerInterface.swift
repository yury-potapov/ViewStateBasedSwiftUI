import Foundation
import Combine

protocol TimeManager: Actor {
//    associatedtype TimeUpdates = AsyncSequence where Element == Date
    
    var startTime: Date { get }
    var currentTime: Date { get }
    var timeUpdates: AsyncStream<Date> { get }
}
