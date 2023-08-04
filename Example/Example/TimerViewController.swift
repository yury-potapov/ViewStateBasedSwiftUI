import SwiftUI
import ViewStateBasedSwiftUI

typealias TimerViewController = AsyncUIHostingController<TimerView, TimerViewState, Void, EmptyView>

extension TimerViewController {
    convenience init(timeManager: TimeManager) {
        let interactor = TimerViewInteractor(timeManager: timeManager)
        self.init(viewStatesProvider: interactor) {
            TimerView(viewModel: $0)
        } placeholder: {
            EmptyView()
        }
    }
}

private final class TimerViewInteractor: AsyncViewStatesProvider {
    
    var initialViewState: TimerViewState {
        get async {
            await TimerViewState(startDate: timeManager.startTime, date: timeManager.currentTime)
        }
    }
    
    // Can be written with `some`?
    var viewStateUpdates: AsyncMapSequence<AsyncStream<Date>, TimerViewState> {
        get async {
            let startDate = await timeManager.startTime
            let dateUpdates = await timeManager.timeUpdates
            return dateUpdates.map { TimerViewState(startDate: startDate, date: $0) }
        }
    }
    
    init(timeManager: TimeManager) {
        self.timeManager = timeManager
        stream = AsyncStream { continuation in
            
        }
    }
    
    private let timeManager: TimeManager
    private let stream: AsyncStream<TimerViewState>
    
}
