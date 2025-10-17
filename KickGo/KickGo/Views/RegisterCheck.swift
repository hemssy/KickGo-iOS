
import Foundation
import UIKit
import SnapKit

/// protocol 채택한 이유
/// 사용하지 않았다면 RegisterView와 RegisterLocationSettinView에 의존하여 데이터를 가져와야 합니다.
protocol RegisterCheckDelegate: AnyObject {
    func registerCheckDidTapNext() -> [(title: String, value: String)]
}

class RegisterCheck: UIView, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RegisterCheckCell.identifier, for: indexPath) as? RegisterCheckCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let item = infoDatas[indexPath.row]
        cell.configure(title: item.title, value: item.value)
        return cell
    }
    
    weak var delegate: RegisterCheckDelegate?
    var infoDatas: [(title: String, value: String)] = []
    
    //상단 숫자
    let numsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = Color2563EB
        label.textColor = .white
        label.text = "3"
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        return label
    }()
    // 등록 완료 label
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "등록 완료"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    //등록 정보 확인 상세설명 label
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "입력한 정보를 확인해주세요."
        return label
    }()
    
    //하단 이전, 등록완료 컨테이너뷰
    let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let prevButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이전", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = Color10B981
        button.layer.cornerRadius = 12
        return button
    }()
    
    let finishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("등록완료", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = Color10B981
        button.layer.cornerRadius = 12
        return button
    }()
    
    //등록 정보 확인 테이블 뷰
    lazy var infoTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.register(RegisterCheckCell.self, forCellReuseIdentifier: RegisterCheckCell.identifier)
        return tableView
    }()
    
    //등록 완료 준비 컨테이너 뷰
    let checkInfoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorECFDF5
        view.layer.cornerRadius = 12
        return view
    }()
    
    // 등록 완료 준비 제목 label
    let checkInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "등록 완료 준비"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = Color10B981
        
        return label
    }()
    // 등록 완료 준비 서브 label
    let checkInfoSubLabel: UILabel = {
        let label = UILabel()
        label.text = "위 정보로 킥보드를 등록하시겠습니까? 등록 후에도 위치는 언제든 변경할 수 있습니다."
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = Color10B981
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        //self(RegisterLocateSettingView)에 상속
        [numsLabel, infoLabel, detailLabel,checkInfoContainerView,infoTableView,bottomContainerView].forEach{
            self.addSubview($0)
        }
        //bottomContainerView에 상속
        [prevButton,finishButton].forEach{
            bottomContainerView.addSubview($0)
        }
        
        // checkInfoContainerView에 상속
        [checkInfoLabel,checkInfoSubLabel].forEach{
            checkInfoContainerView.addSubview($0)
        }
        
    }
    func setupLayout() {
        numsLabel.snp.makeConstraints{
            $0.top.equalTo(safeAreaLayoutGuide).inset(20)
            $0.width.height.equalTo(32)
            $0.centerX.equalToSuperview()
        }
        infoLabel.snp.makeConstraints{
            $0.top.equalTo(numsLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        detailLabel.snp.makeConstraints{
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        bottomContainerView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.top.equalTo(prevButton.snp.top).offset(-16)
        }
        
        infoTableView.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(240)
            
        }
        
        checkInfoContainerView.snp.makeConstraints {
            $0.top.equalTo(infoTableView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(checkInfoContainerView.snp.top).offset(-20)
            $0.height.equalTo(140)
        }
        bottomContainerSetUpLayout()
        checkInfoContainerSetUpLayout()
    }
    
    //bottomContainerView 하위 요소 오토레이아웃 설정
    func bottomContainerSetUpLayout() {
        // 이전 버튼
        prevButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(finishButton.snp.leading).offset(-20)
        }
        // 다음 버튼
        finishButton.snp.makeConstraints {
            $0.width.equalTo(prevButton)
            $0.centerY.height.equalTo(prevButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(prevButton.snp.trailing).offset(20)
            
        }
    }
    
    func checkInfoContainerSetUpLayout() {
        checkInfoLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(30)
        }
        checkInfoSubLabel.snp.makeConstraints {
            $0.top.equalTo(checkInfoLabel.snp.bottom)
            $0.leading.trailing.equalTo(checkInfoLabel)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
    
    //테이블 뷰 delegate, dataSource 설정
    private func setupTableView() {
        infoTableView.delegate = self
        infoTableView.dataSource = self
        infoTableView.rowHeight = 60
    }
    
    func reloadData(){
        self.infoDatas = delegate?.registerCheckDidTapNext() ?? []
        self.infoTableView.reloadData()
    }
}
