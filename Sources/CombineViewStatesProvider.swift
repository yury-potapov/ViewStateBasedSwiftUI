import Combine

public protocol CombineViewStatesProvider<ViewState> {
    associatedtype ViewState
    associatedtype ViewStateUpdates: Publisher
    where ViewStateUpdates.Output == ViewState, ViewStateUpdates.Failure == Never

    @MainActor var initialViewState: ViewState { get }
    @MainActor var viewStateUpdates: ViewStateUpdates { get }
}

public protocol CombineAsyncViewStatesProvider<ViewState> {
    associatedtype ViewState
    associatedtype ViewStateUpdates: Publisher
    where ViewStateUpdates.Output == ViewState, ViewStateUpdates.Failure == Never

    var initialViewState: ViewState { get async }
    var viewStateUpdates: ViewStateUpdates { get async }
}
