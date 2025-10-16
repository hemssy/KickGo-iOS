
import Foundation
import UIKit
import SnapKit

class RegisterCheckCell: UITableViewCell {
    
    static let identifier = "RegisterCheckCell"
    
    // 모델명
    let modelLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    // 시리얼 넘버
    let serialLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    // 배터리
    let batteryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    // 배치 위치
    let positionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        [modelLabel,serialLabel,batteryLabel,positionLabel].forEach{
            contentView.addSubview($0)
        }
    }
    
    func setupLayout(){
        modelLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        serialLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        batteryLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        positionLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(modelLabel)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    public func configure(title: String, value: String) {
        modelLabel.text = title
        serialLabel.text = value
    }
}
