import SwiftUI
import ViewStateBasedSwiftUI

public struct TimerViewState { // Sendable
    let startDate: Date
    let date: Date
    
    public init(startDate: Date, date: Date) {
        self.startDate = startDate
        self.date = date
    }
}

import Combine

public protocol TimerViewModel {
    var startTime: Date { get async }
    var timeUpdates: AsyncStream<Date> { get async }
}

public struct TimerView: View {
    public typealias ViewModel = TimerViewModel //ViewStateModel<TimerViewState, Void>
    
    public init(viewModel: TimerViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Text(datesRange, format: .timeDuration)
            .task {
                await startDate.setValue(viewModel.startTime)
                await currentDate.attach(asyncSequence: viewModel.timeUpdates)
            }
    }

    private var datesRange: Range<Date> {
        guard startDate.value <= currentDate.value else {
            return Range<Date>(
                uncheckedBounds: (
                    Date(timeIntervalSince1970: .zero),
                    Date(timeIntervalSince1970: .zero)
                )
            )

        }
        return startDate.value..<currentDate.value
    }

    @StateObject
    private var startDate = ObservableState(Date(timeIntervalSince1970: .zero))

    @StateObject
    private var currentDate = ObservableState(Date(timeIntervalSince1970: .zero))

    private let viewModel: ViewModel
}
