import AsyncAlgorithms
import Combine
import Foundation

actor SystemTimeManager: TimeManager {
    
    init(startDate: Date = Date()) {
        startTime = startDate
        currentTime = startTime
        Task {
            await start()
        }
    }
    
    // MARK: - TimeManager
    
    let startTime: Date
    private(set) var currentTime: Date {
        didSet {
            timeStreamContinuation?.yield(currentTime)
            timePublisherImpl.send(currentTime)
        }
    }
    
    private(set) lazy var timeUpdates = AsyncStream<Date> { continuation in
        timeStreamContinuation = continuation
    }
    
//    var timePublisher: any Publisher<Date, Never> { timePublisherImpl }
    
    // MARK: - Private
    
    private var duration: Duration = .zero
    private let step: Duration = .seconds(1)
    
    private var timeStreamContinuation: AsyncStream<Date>.Continuation? = nil
    private let timePublisherImpl = PassthroughSubject<Date, Never>()
    
    private func start() async {
        let startClock = SuspendingClock.Instant.now
        for await newClock in AsyncTimerSequence.repeating(every: .seconds(1)) {
            duration = newClock.duration(to: startClock)
            let newTimeInterval = duration.timeInterval
            currentTime = Date(timeInterval: newTimeInterval, since: startTime)
        }
    }

}

private extension Duration {
  /// Possibly lossy conversion to TimeInterval
  var timeInterval: TimeInterval {
    TimeInterval(components.seconds) + Double(components.attoseconds) * 1e-18
  }
}
