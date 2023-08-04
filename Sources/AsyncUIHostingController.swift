import SwiftUI

@MainActor
open class AsyncUIHostingController<Content: View, ViewState, ViewAction, P: View>:
    UIHostingController<_ConditionalContent<Content, P>>
{
    public init<ViewStatesProvider: AsyncViewStatesProvider>(
        viewStatesProvider: ViewStatesProvider,
        actionsHandler: ((ViewAction) -> Void)? = nil,
        contentBuilder: @escaping (ViewStateModel<ViewState, ViewAction>) -> Content,
        placeholder: @escaping () -> P
    ) where ViewStatesProvider.ViewState == ViewState {

        super.init(rootView: Self.buildRoot(for: nil, contentBuilder: contentBuilder, placeholder: placeholder))

        Task {
            let initial = await viewStatesProvider.initialViewState
            let updates = await viewStatesProvider.viewStateUpdates
            let viewModel = ViewStateModel<ViewState, ViewAction>(
                initial,
                updatesSequence: updates,
                actionsHandler: actionsHandler
            )
            let root = Self.buildRoot(for: viewModel, contentBuilder: contentBuilder, placeholder: placeholder)
            self.rootView = root
            self.viewModel = viewModel
        }

    }

    public required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @ViewBuilder
    private static func buildRoot<P: View>(
        for viewModel: ViewStateModel<ViewState, ViewAction>?,
        contentBuilder: (ViewStateModel<ViewState, ViewAction>) -> Content,
        placeholder: () -> P
    ) -> _ConditionalContent<Content, P> {

        if let viewModel {
            contentBuilder(viewModel)
        } else {
            placeholder()
        }

    }

    //  viewModel have to be stored, because it's @ObservedObject in View
    private var viewModel: ViewStateModel<ViewState, ViewAction>?
}

