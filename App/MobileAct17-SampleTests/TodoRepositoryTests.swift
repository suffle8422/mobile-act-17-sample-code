//
//  TodoRepositoryTests.swift
//  MobileAct17-Sample
//
//  Created by Ibuki Onishi on 2025/11/16.
//

import Foundation
import Testing
@testable import MobileAct17_Sample

struct TodoRepositoryTests {

    @Test("初期状態でfetchTodosが空配列を返す")
    func testFetchTodosReturnsEmptyArrayInitially() async throws {
        let client = SwiftDataClient.testValue
        let repository = TodoRepository(swiftDataClient: client)

        let todos = await repository.fetchTodos()

        #expect(todos.isEmpty)
    }

    @Test("insertTodoでTodoが追加され、fetchTodosで取得できる")
    func testInsertTodoAndFetch() async throws {
        let client = SwiftDataClient.testValue
        let repository = TodoRepository(swiftDataClient: client)
        let todo = TodoEntity(id: UUID(), content: "テストTodo")

        await repository.insertTodo(entity: todo)
        let todos = await repository.fetchTodos()

        #expect(todos.count == 1)
        #expect(todos.first?.id == todo.id)
        #expect(todos.first?.content == todo.content)
    }

    @Test("複数のTodoを挿入して全て取得できる")
    func testInsertMultipleTodos() async throws {
        let client = SwiftDataClient.testValue
        let repository = TodoRepository(swiftDataClient: client)
        let todo1 = TodoEntity(id: UUID(), content: "Todo 1")
        let todo2 = TodoEntity(id: UUID(), content: "Todo 2")
        let todo3 = TodoEntity(id: UUID(), content: "Todo 3")

        await repository.insertTodo(entity: todo1)
        await repository.insertTodo(entity: todo2)
        await repository.insertTodo(entity: todo3)
        let todos = await repository.fetchTodos()

        #expect(todos.count == 3)
        let ids = todos.map { $0.id }
        #expect(ids.contains(todo1.id))
        #expect(ids.contains(todo2.id))
        #expect(ids.contains(todo3.id))
    }

    @Test("deleteTodoでTodoが削除される")
    func testDeleteTodo() async throws {
        let client = SwiftDataClient.testValue
        let repository = TodoRepository(swiftDataClient: client)
        let todo = TodoEntity(id: UUID(), content: "削除されるTodo")
        await repository.insertTodo(entity: todo)

        await repository.deleteTodo(id: todo.id)
        let todos = await repository.fetchTodos()

        #expect(todos.isEmpty)
    }
}
