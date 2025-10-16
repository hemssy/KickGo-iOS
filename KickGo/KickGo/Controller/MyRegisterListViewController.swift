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
        hideKeyboardWhenTappedAround()
        setupTableView()
        fetchScooters()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        
        // 여기 커스텀한 셀 등록으로 변경함
        tableView.register(ScooterCell.self, forCellReuseIdentifier: "ScooterCell")
        
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func fetchScooters() {
        let context = CoreDataStack.context
        let request: NSFetchRequest<ScooterEntity> = ScooterEntity.fetchRequest()

        // 현재 로그인한 회원 ID로 필터링하기(필터링하면 계정마다 계정에 해당하는 정보가 보여짐)
        if let userID = UserDefaults.standard.string(forKey: "loggedInUserID") {
            request.predicate = NSPredicate(format: "ownerID == %@", userID)
        }

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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 커스텀 셀로 교체
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScooterCell", for: indexPath) as? ScooterCell else {
            return UITableViewCell()
        }

        let s = scooters[indexPath.row]
        cell.configure(
            modelName: s.modelName,
            serial: s.serialNumber,
            battery: Int(s.battery),
            position: s.position
        )

        return cell
    }
}

