import AsyncAlgorithms
import SwiftUI
import ViewStateBasedSwiftUI

typealias TimerViewControllerOnViewState = AsyncUIHostingController<
    TimerViewOnViewState,
    TimerViewState,
    Void,
    EmptyView
>

extension TimerViewControllerOnViewState {
    convenience init(timeManager: TimeManager) {
        let interactor = TimerViewInteractor(timeManager: timeManager)
        self.init(viewStatesProvider: interactor) {
            TimerViewOnViewState(viewModel: $0)
        } placeholder: {
            EmptyView()
        }
    }
}

private final class TimerViewInteractor: AsyncViewStatesProvider, Sendable {

    var initialViewState: TimerViewState {
        get async {
            await TimerViewState(startDate: timeManager.startTime, date: timeManager.currentTime)
        }
    }

    var viewStateUpdates: any ViewStateUpdates<TimerViewState> {
        get async {
            let startDate = await timeManager.startTime
            let dateUpdates = await timeManager.timeUpdates
            let baseUpdates = dateUpdates.map { TimerViewState(startDate: startDate, date: $0) }
            return ViewStateSequenceWrapper(baseUpdates)
        }
    }

    init(timeManager: TimeManager) {
        self.timeManager = timeManager
    }

    private let timeManager: TimeManager
}
