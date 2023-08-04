import SwiftUI

@MainActor
open class AsyncUIHostingController<Content: View, ViewState, ViewAction>:
    UIHostingController<_ConditionalContent<Content, EmptyView>>
{
    public init<ViewStatesProvider: AsyncViewStatesProvider>(
        viewStatesProvider: ViewStatesProvider,
        actionsHandler: ((ViewAction) -> Void)? = nil,
        contentBuilder: @escaping (ViewStateModel<ViewState, ViewAction>) -> Content
    ) where ViewStatesProvider.ViewState == ViewState {

        super.init(rootView: Self.buildRoot(for: nil, contentBuilder: contentBuilder))

        Task {
            let initial = await viewStatesProvider.initialViewState
            let updates = await viewStatesProvider.viewStateUpdates
            let viewModel = ViewStateModel<ViewState, ViewAction>(
                initial,
                updatesSequence: updates,
                actionsHandler: actionsHandler
            )
            let root = Self.buildRoot(for: viewModel, contentBuilder: contentBuilder)
            self.rootView = root
            self.viewModel = viewModel
        }

    }

    public required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @ViewBuilder
    private static func buildRoot(
        for viewModel: ViewStateModel<ViewState, ViewAction>?,
        contentBuilder: (ViewStateModel<ViewState, ViewAction>) -> Content
    ) -> _ConditionalContent<Content, EmptyView> {

        if let viewModel {
            contentBuilder(viewModel)
        } else {
            EmptyView() // Placeholder
        }

    }
    
    private var viewModel: ViewStateModel<ViewState, ViewAction>?

}

