import UIKit
import CoreData

class RentalHistoryViewController: UIViewController {

    // 사용할 프로퍼티들
    private var rentals: [RentalScooterEntity] = []      // 표시할 데이터
    private let tableView = UITableView()                // 테이블뷰

    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "이용 내역"
        view.backgroundColor = .systemBackground

        setupTableView()     // 테이블뷰 만들기 (넣을 자리)
        setupDummyData()     // 임시 더미데이터 (넣는 내용)
    }

    // 테이블뷰 셋업
    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

    // 더미데이터(나중에 삭제할예정!! 이 부분 코드는 무시해도 괜찮습니다..)
    private func setupDummyData() {
        let ctx = CoreDataStack.context

        let dummy1 = RentalScooterEntity(context: ctx)
        dummy1.id = UUID()
        dummy1.userEmail = "kickgo@example.com"
        dummy1.scooterModel = "킥고 라이트"
        dummy1.startTime = Date().addingTimeInterval(-3600)
        dummy1.endTime = Date()
        dummy1.duration = 30
        dummy1.payment = 2500

        let dummy2 = RentalScooterEntity(context: ctx)
        dummy2.id = UUID()
        dummy2.userEmail = "kickgo@example.com"
        dummy2.scooterModel = "킥고 맥스"
        dummy2.startTime = Date().addingTimeInterval(-7200)
        dummy2.endTime = Date().addingTimeInterval(-6900)
        dummy2.duration = 5
        dummy2.payment = 700

        try? ctx.save()
        rentals = [dummy1, dummy2]
    }
}

// 테이블뷰 데이터소스
extension RentalHistoryViewController: UITableViewDataSource {
    
    // 테이블뷰에서 셀 몇 개 만들어야되는지
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rentals.count
    }
    
    // 테이블뷰 꾸미기
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let record = rentals[indexPath.row]

        // 날짜
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"

        // 옵셔널 처리
        let start = record.startTime.map { formatter.string(from: $0) } ?? "-"
        let end = record.endTime.map { formatter.string(from: $0) } ?? "-"

        // 텍스트라벨
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 15)
        cell.textLabel?.text =
        """
        이용일시: \(start) ~ \(end)
        이용시간: \(Int(record.duration))분
        결제금액: \(record.payment)원
        """

        return cell
    }
}

