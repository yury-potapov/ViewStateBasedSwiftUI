import AsyncAlgorithms
import SwiftUI
import ViewStateBasedSwiftUI

final class TimerViewController: UIHostingController<TimerView> {
    init(viewModel: TimerViewModel) {
        super.init(rootView: TimerView(viewModel: viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//typealias TimerViewController = AsyncUIHostingController<TimerView, TimerViewState, Void, EmptyView>
//
//extension TimerViewController {
//    convenience init(timeManager: TimeManager) {
//        let interactor = TimerViewInteractor(timeManager: timeManager)
//        self.init(viewStatesProvider: interactor) {
//            TimerView(viewModel: TimerViewModelImpl(timeManager: timeManager))
//        } placeholder: {
//            EmptyView()
//        }
//    }
//}

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
