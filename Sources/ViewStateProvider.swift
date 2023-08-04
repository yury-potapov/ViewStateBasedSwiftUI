public protocol ViewStateUpdates<ViewState>: AsyncSequence where Element == ViewState {
    associatedtype ViewState
}

public protocol ViewStatesProvider<ViewState> {
    associatedtype ViewState

    @MainActor var initialViewState: ViewState { get }
    @MainActor var viewStateUpdates: any ViewStateUpdates<ViewState> { get }
}

public protocol AsyncViewStatesProvider<ViewState> {
    associatedtype ViewState

    var initialViewState: ViewState { get async }
    var viewStateUpdates: any ViewStateUpdates<ViewState> { get async }
}
