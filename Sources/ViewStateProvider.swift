public protocol ViewStatesProvider<ViewState> {
    associatedtype ViewState
    associatedtype ViewStateUpdates: AsyncSequence where ViewStateUpdates.Element == ViewState

    @MainActor var initialViewState: ViewState { get }
    @MainActor var viewStateUpdates: ViewStateUpdates { get }
}

public protocol AsyncViewStatesProvider<ViewState> {
    associatedtype ViewState
    associatedtype ViewStateUpdates: AsyncSequence where ViewStateUpdates.Element == ViewState

    var initialViewState: ViewState { get async }
    var viewStateUpdates: ViewStateUpdates { get async }
}
