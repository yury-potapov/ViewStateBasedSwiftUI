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

public struct TimerView: View {
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

struct TimerView_Previews : PreviewProvider {

    private static var viewModel = TimerView.ViewModel(
        TimerViewState(
            startDate: Date(timeIntervalSince1970: .zero),
            date: Date(timeIntervalSince1970: .zero)
        )
    )

    static var previews: some View {
        TimerView(viewModel: viewModel)
    }

}
