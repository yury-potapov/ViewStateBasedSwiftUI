import Combine
import Foundation

@MainActor
public final class ObservableState<Value>: ObservableObject {
    @Published public private(set) var value: Value

    public init(_ initial: Value) {
        value = initial
    }

    public func setValue(_ newValue: Value) {
        value = newValue
    }

    public func attach(publisher: some Publisher<Value, Never>) {
        canceller = publisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.value = $0 }
    }

    public func attach<AS: AsyncSequence>(asyncSequence: AS)
        where AS.Element == Value, AS: Sendable, Value: Sendable
    {
        task = Task {
            for try await newValue in asyncSequence {
                value = newValue
            }
        }
    }

    private var canceller: Cancellable?
    private var task: Task<(), Error>?
}
