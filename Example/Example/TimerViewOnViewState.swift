import SwiftUI
import ViewStateBasedSwiftUI

public struct TimerViewState: Sendable {
    let startDate: Date
    let date: Date

    public init(startDate: Date, date: Date) {
        self.startDate = startDate
        self.date = date
    }
}

public struct TimerViewOnViewState: View {
    public typealias ViewModel = ViewStateModel<TimerViewState, Void>

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Text(
            viewModel.viewState.startDate..<viewModel.viewState.date,
            format: .timeDuration
        )
    }

    @ObservedObject
    private var viewModel: ViewModel
}
