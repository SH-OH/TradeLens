public protocol WebSocketManagementUseCase: Sendable {
    func connect() async throws
    func subscribeAll() async throws
    func disconnect() async
}
