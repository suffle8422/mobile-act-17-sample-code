import Foundation

protocol TodoRepositoryProtocol: Sendable {
    func fetchTodos() async -> [TodoEntity]
    func insertTodo(entity: TodoEntity) async
    func deleteTodo(id: UUID) async
}
