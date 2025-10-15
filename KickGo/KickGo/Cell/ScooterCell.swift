import UIKit
import SnapKit

class ScooterCell: UITableViewCell {

    private let cardView = UIView()
    private let modelLabel = UILabel()
    private let idLabel = UILabel()
    private let batteryIcon = UIImageView(image: UIImage(systemName: "battery.0"))
    private let batteryLabel = UILabel()
    private let locationIcon = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
    private let positionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        // 카드 배경
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }

        // 공통 라벨 스타일
        [modelLabel, idLabel, batteryLabel, positionLabel].forEach {
            $0.font = .systemFont(ofSize: 15)
            $0.textColor = .black
        }

        // 아이콘 스타일
        [batteryIcon, locationIcon].forEach {
            $0.tintColor = .black
            $0.contentMode = .scaleAspectFit
            $0.snp.makeConstraints { make in
                make.size.equalTo(16)
            }
        }

        // 상단 스택 (모델명 + ID)
        let topStack = UIStackView(arrangedSubviews: [modelLabel, idLabel])
        topStack.axis = .vertical
        topStack.spacing = 0

        // 하단 스택 (배터리 + 위치)
        let batteryStack = UIStackView(arrangedSubviews: [batteryIcon, batteryLabel])
        batteryStack.axis = .horizontal
        batteryStack.spacing = 4
        batteryStack.alignment = .center

        let locationStack = UIStackView(arrangedSubviews: [locationIcon, positionLabel])
        locationStack.axis = .horizontal
        locationStack.spacing = 4
        locationStack.alignment = .center

        let bottomStack = UIStackView(arrangedSubviews: [batteryStack, locationStack])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .equalSpacing

        // 전체 스택
        let mainStack = UIStackView(arrangedSubviews: [topStack, bottomStack])
        mainStack.axis = .vertical
        mainStack.spacing = 6

        cardView.addSubview(mainStack)
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }

    func configure(modelName: String?, serial: String?, battery: Int, position: String?) {
        modelLabel.text = modelName ?? "모델 정보 없음"
        idLabel.text = "ID: \(serial ?? "-")"
        batteryLabel.text = "\(battery)%"
        positionLabel.text = position ?? "위치 정보 없음"
    }
}

