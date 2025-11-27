import Foundation
import SwiftData

@Model
final class TodoModel {
    @Attribute(.unique) var id: UUID
    var content: String

    init(id: UUID, content: String) {
        self.id = id
        self.content = content
    }
}

extension TodoModel: EntityConvertible {
    typealias Entity = TodoEntity

    convenience init(entity: TodoEntity) {
        self.init(
            id: entity.id,
            content: entity.content
        )
    }
    
    func update(entity: TodoEntity) {
        self.id = entity.id
        self.content = entity.content
    }
    
    func entity() -> TodoEntity {
        .init(id: id, content: content)
    }
}
