import Combine
import Foundation

public final class ViewStateModel<ViewState, UIAction>: ObservableObject {
    public typealias ActionsHandler = (UIAction) -> Void

    @Published public private(set) var viewState: ViewState

    public init<PublisherT: Publisher>(
        _ initialViewState: ViewState,
        updates: PublisherT,
        actionsHandler: ActionsHandler?
    ) where PublisherT.Output == ViewState {
        self.actionsHandler = actionsHandler
        self.viewState = initialViewState
        canceller = updates.sink(
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

    public func dispatch(action: UIAction) {
        actionsHandler?(action)
    }

    private let actionsHandler: ActionsHandler?
    private var canceller: AnyCancellable?
}

extension ViewStateModel {
    @MainActor
    public convenience init<PublisherT: Publisher>(
        updates: PublisherT,
        actionsHandler: ActionsHandler?
    ) async throws where PublisherT.Output == ViewState
    {
        let initial = try await updates.firstAsync()
        self.init(initial, updates: updates, actionsHandler: actionsHandler)
    }
}



// Empty updates
public extension ViewStateModel {

    convenience init(_ initialViewState: ViewState, actionsHandler: ActionsHandler?) {
        self.init(initialViewState, updates: Empty<ViewState, Never>(), actionsHandler: actionsHandler)
    }

}

// Empty ActionsHandler
public extension ViewStateModel where UIAction == Void {

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
