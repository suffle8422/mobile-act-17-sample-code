//
//  TodoStoreTests.swift
//  MobileAct17-Sample
//
//  Created by Ibuki Onishi on 2025/11/16.
//

import Foundation
import Testing
@testable import MobileAct17_Sample

@MainActor
struct TodoStoreTests {
    @Test("初期化時にrepositoryからTodoを取得してtodosプロパティに設定する")
    func testInitialization() async throws {
        let initialTodos = [
            TodoEntity(id: UUID(), content: "Todo 1"),
            TodoEntity(id: UUID(), content: "Todo 2")
        ]
        let mockRepository = MockTodoRepository(initialTodos: initialTodos)
        let store = TodoStore(todoRepository: mockRepository)

        await store.syncTodos()

        #expect(mockRepository.fetchTodosCallCount == 1)
        #expect(store.todos.count == 2)
        #expect(store.todos[0].id == initialTodos[0].id)
        #expect(store.todos[1].id == initialTodos[1].id)
    }

    @Test("初期化時にrepositoryが空の場合、todosプロパティも空になる")
    func testInitializationWithEmptyRepository() async throws {
        let mockRepository = MockTodoRepository()
        let store = TodoStore(todoRepository: mockRepository)

        await store.syncTodos()

        #expect(mockRepository.fetchTodosCallCount == 1)
        #expect(store.todos.isEmpty)
    }

    @Test("insertTodoでrepositoryへの保存とtodos配列への追加が行われる")
    func testInsertTodo() async throws {
        let mockRepository = MockTodoRepository()
        let store = TodoStore(todoRepository: mockRepository)

        await store.syncTodos()

        let newTodo = TodoEntity(id: UUID(), content: "新しいTodo")
        await store.insertTodo(entity: newTodo)

        #expect(mockRepository.insertTodoCallCount == 1)
        #expect(store.todos.count == 1)
        #expect(store.todos[0].id == newTodo.id)
        #expect(store.todos[0].content == newTodo.content)
    }

    @Test("複数のTodoを挿入できる")
    func testInsertMultipleTodos() async throws {
        let mockRepository = MockTodoRepository()
        let store = TodoStore(todoRepository: mockRepository)
        await store.syncTodos()

        let todo1 = TodoEntity(id: UUID(), content: "Todo 1")
        let todo2 = TodoEntity(id: UUID(), content: "Todo 2")
        let todo3 = TodoEntity(id: UUID(), content: "Todo 3")

        await store.insertTodo(entity: todo1)
        await store.insertTodo(entity: todo2)
        await store.insertTodo(entity: todo3)

        #expect(mockRepository.insertTodoCallCount == 3)
        #expect(store.todos.count == 3)
        let ids = store.todos.map { $0.id }
        #expect(ids.contains(todo1.id))
        #expect(ids.contains(todo2.id))
        #expect(ids.contains(todo3.id))
    }

    @Test("deleteTodoでrepositoryからの削除とtodos配列からの削除が行われる")
    func testDeleteTodo() async throws {
        let initialTodo = TodoEntity(id: UUID(), content: "削除されるTodo")
        let mockRepository = MockTodoRepository(initialTodos: [initialTodo])
        let store = TodoStore(todoRepository: mockRepository)
        await store.syncTodos()

        await store.deleteTodo(id: initialTodo.id)

        #expect(mockRepository.deleteTodoCallCount == 1)
        #expect(store.todos.isEmpty)
    }

    @Test("複数のTodoから特定のTodoを削除できる")
    func testDeleteSpecificTodo() async throws {
        let todo1 = TodoEntity(id: UUID(), content: "Todo 1")
        let todo2 = TodoEntity(id: UUID(), content: "Todo 2")
        let todo3 = TodoEntity(id: UUID(), content: "Todo 3")
        let mockRepository = MockTodoRepository(initialTodos: [todo1, todo2, todo3])
        let store = TodoStore(todoRepository: mockRepository)
        await store.syncTodos()

        await store.deleteTodo(id: todo2.id)

        #expect(mockRepository.deleteTodoCallCount == 1)
        #expect(store.todos.count == 2)
        let ids = store.todos.map { $0.id }
        #expect(ids.contains(todo1.id))
        #expect(!ids.contains(todo2.id))
        #expect(ids.contains(todo3.id))
    }

    @Test("挿入と削除を組み合わせた操作が正しく動作する")
    func testInsertAndDeleteCombination() async throws {
        let mockRepository = MockTodoRepository()
        let store = TodoStore(todoRepository: mockRepository)
        await store.syncTodos()

        let todo1 = TodoEntity(id: UUID(), content: "Todo 1")
        let todo2 = TodoEntity(id: UUID(), content: "Todo 2")

        await store.insertTodo(entity: todo1)
        await store.insertTodo(entity: todo2)
        await store.deleteTodo(id: todo1.id)

        #expect(mockRepository.insertTodoCallCount == 2)
        #expect(mockRepository.deleteTodoCallCount == 1)
        #expect(store.todos.count == 1)
        #expect(store.todos[0].id == todo2.id)
    }
}

@MainActor
final class MockTodoRepository: TodoRepositoryProtocol {
    private var todos: [TodoEntity] = []

    // 検証用のプロパティ
    private(set) var fetchTodosCallCount = 0
    private(set) var insertTodoCallCount = 0
    private(set) var deleteTodoCallCount = 0

    init(initialTodos: [TodoEntity] = []) {
        self.todos = initialTodos
    }

    func fetchTodos() -> [TodoEntity] {
        fetchTodosCallCount += 1
        return todos
    }

    func insertTodo(entity: TodoEntity) {
        insertTodoCallCount += 1
        todos.append(entity)
    }

    func deleteTodo(id: UUID) {
        deleteTodoCallCount += 1
        todos = todos.filter { $0.id != id }
    }
}

