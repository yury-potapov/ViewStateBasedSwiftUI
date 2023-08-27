import AsyncAlgorithms
import SwiftUI
import ViewStateBasedSwiftUI

final class TimerViewControllerOnViewModel: UIHostingController<TimerViewOnViewModel> {
    init(viewModel: TimerViewModel) {
        super.init(rootView: TimerViewOnViewModel(viewModel: viewModel))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
