import CoreData
import UIKit

enum CoreDataStack {
    // PersistentContainer 생성
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KickGoModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("코어데이터 로드 실패: \(error)")
            }
        }
        return container
    }()

    // context 접근
    static var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // 저장 함수
    static func saveContextIfNeeded() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("저장 실패: \(error.localizedDescription)")
            }
        }
    }
}

