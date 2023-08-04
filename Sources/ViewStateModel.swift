import Combine
import Foundation

@MainActor
public final class ViewStateModel<ViewState, ViewAction>: ObservableObject {
    public typealias ActionsHandler = (ViewAction) -> Void

    @Published public private(set) var viewState: ViewState

    public init<PublisherT: Publisher>(
        _ initialViewState: ViewState,
        updates: PublisherT,
        actionsHandler: ActionsHandler?
    ) where PublisherT.Output == ViewState {
        self.actionsHandler = actionsHandler
        self.viewState = initialViewState
        canceller = updates
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completed in
                    switch completed {
                    case .failure(let err):
                        assertionFailure("Updates completed with error: \(err.localizedDescription)")
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] in
                    self?.viewState = $0
                }
            )
    }
    
    public init<ViewStatesSequence: AsyncSequence>(
        _ initialViewState: ViewState,
        updatesSequence: ViewStatesSequence,
        actionsHandler: ActionsHandler?
    ) where ViewStatesSequence.Element == ViewState {
        self.actionsHandler = actionsHandler
        viewState = initialViewState
        Task {
            for try await newViewState in updatesSequence {
                await MainActor.run {
                    viewState = newViewState
                }
            }
        }
    }

    public func dispatch(action: ViewAction) {
        actionsHandler?(action)
    }

    private let actionsHandler: ActionsHandler?
    private var canceller: Cancellable?
}

// Empty updates
public extension ViewStateModel {

    convenience init(_ initialViewState: ViewState, actionsHandler: ActionsHandler?) {
        self.init(initialViewState, updates: Empty<ViewState, Never>(), actionsHandler: actionsHandler)
    }

}

// Empty ActionsHandler
public extension ViewStateModel where ViewAction == Void {

    convenience init(_ initialViewState: ViewState) {
        self.init(initialViewState, updates: Empty<ViewState, Never>(), actionsHandler: nil)
    }

    convenience init<PublisherT: Publisher>(
        _ initialViewState: ViewState,
        updates: PublisherT
    ) where PublisherT.Output == ViewState {
        self.init(initialViewState, updates: updates, actionsHandler: nil)
    }

}
