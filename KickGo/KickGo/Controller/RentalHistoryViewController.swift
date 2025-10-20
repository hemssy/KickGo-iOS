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
        fetchRentalHistory() // 더미데이터 자리에 이용내역 실제데이터 가져옴
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

    private func fetchRentalHistory() {
        let ctx = CoreDataStack.context
        let request: NSFetchRequest<RentalScooterEntity> = RentalScooterEntity.fetchRequest()
        
        // 로그인된 사용자 이메일 가져오기
        let defaults = UserDefaults.standard
        guard let userEmail = defaults.string(forKey: "loggedInUserID") else {
            print("로그인 정보 없음 (UserDefaults에 loggedInUserID 없음)")
            return
        }

        // 계정별 필터링 (로그인한 사용자만)
        request.predicate = NSPredicate(format: "userEmail == %@", userEmail)
        
        do {
            rentals = try ctx.fetch(request)
            tableView.reloadData()
            print("\(userEmail) 이용 내역 불러오기 성공 (\(rentals.count)건)")
        } catch {
            print("이용 내역 불러오기 실패: \(error.localizedDescription)")
        }
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

