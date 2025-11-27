import Foundation

@MainActor
protocol TodoStoreProtocol: Observable, Sendable {
    var todos: [TodoEntity] { get }
    func insertTodo(entity: TodoEntity) async
    func deleteTodo(id: UUID) async
}
