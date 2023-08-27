import SwiftUI
import ViewStateBasedSwiftUI

public typealias TimerViewTimeUpdates = AsyncStream<Date>

public protocol TimerViewModel {
    var startTime: Date { get async }  // async to alow an actor to be the source of truth
    var timeUpdates: TimerViewTimeUpdates { get async }
}

public struct TimerViewOnViewModel: View {
    
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
            return Range<Date>(uncheckedBounds: (.date1970, .date1970))
        }
        return startDate.value..<currentDate.value
    }

    @StateObject private var startDate = ObservableState(Date.date1970)
    @StateObject private var currentDate = ObservableState(Date.date1970)
    private let viewModel: TimerViewModel
}

private extension Date {
    static let date1970: Date = Date(timeIntervalSince1970: .zero)
}
