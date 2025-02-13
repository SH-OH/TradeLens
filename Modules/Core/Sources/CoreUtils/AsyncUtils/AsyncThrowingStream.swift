import Combine
import Foundation

public extension AsyncThrowingStream where Element: Sendable {
    func toAnyPublisher() -> AnyPublisher<Element, Error> {
        let subject = SendablePassthroughSubject<Element>()
        let task = Task {
            do {
                for try await value in self {
                    subject.send(value)
                }
                subject.send(completion: .finished)
            } catch {
                subject.send(completion: .failure(error))
            }
        }
        
        return subject.publisher()
            .handleEvents(receiveCancel: { task.cancel() })
            .eraseToAnyPublisher()
    }
}
