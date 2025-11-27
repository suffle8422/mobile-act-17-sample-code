import Foundation
import SwiftData

protocol EntityConvertible where Self: PersistentModel {
    associatedtype Entity: EntityProtocol
    var id: UUID { get }
    init (entity: Entity)
    func update(entity: Entity)
    func entity() -> Entity
}
