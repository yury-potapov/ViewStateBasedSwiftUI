public struct ViewStateSequenceWrapper<ViewState, BaseSequence: AsyncSequence>: ViewStateUpdates where BaseSequence.Element == ViewState {
    public typealias Element = ViewState

    public init(_ base: BaseSequence) {
        self.base = base
    }

    public func makeAsyncIterator() -> BaseSequence.AsyncIterator {
        base.makeAsyncIterator()
    }

    private let base: BaseSequence
}
