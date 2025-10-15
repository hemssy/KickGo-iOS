import UIKit
import CoreData
import SnapKit

class MyRegisterListViewController: UIViewController, UITableViewDataSource {
    private var scooters: [ScooterEntity] = []
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "내가 등록한 킥보드"
        view.backgroundColor = .systemBackground

        setupTableView()
        fetchScooters()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func fetchScooters() {
        let context = CoreDataStack.context
        let request: NSFetchRequest<ScooterEntity> = ScooterEntity.fetchRequest()

        do {
            scooters = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("불러오기 실패:", error)
        }
    }

    // 테이블뷰 데이터소스
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scooters.count
    }
    
    // 나중에 수정+삭제 UI를 간소화하기 위해서 테이블뷰형태로 만들었습니다!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let s = scooters[indexPath.row]
        cell.textLabel?.text = "\(s.modelName ?? "모델 입력X") - \(s.serialNumber ?? "") (\(s.battery)% )"
        cell.detailTextLabel?.text = s.position // 위치는 밑에 작은 글씨로 표시해줌
        return cell
    }
}

