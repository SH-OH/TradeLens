import Combine
import Foundation

public final class SendablePassthroughSubject<Element: Sendable>: @unchecked Sendable {
    private let subject = PassthroughSubject<Element, Error>()
    private let queue = DispatchQueue(label: "Core.CoreUtils.SendablePassthroughSubject")

    public func send(_ value: Element) {
        Task {
            self.subject.send(value)
        }
    }

    public func send(completion: Subscribers.Completion<Error>) {
        Task {
            self.subject.send(completion: completion)
        }
    }

    public func publisher() -> AnyPublisher<Element, Error> {
        subject.eraseToAnyPublisher()
    }
}
