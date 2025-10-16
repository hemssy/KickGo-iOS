import CoreData
import UIKit

enum CoreDataStack {
    // PersistentContainer 생성
    static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KickGoModel")

        // 마이그레이션 옵션 추가(모델파일 수정하면서 같이 추가함)
        if let description = container.persistentStoreDescriptions.first {
            description.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            description.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        }

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

