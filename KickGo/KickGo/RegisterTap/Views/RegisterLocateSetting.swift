import Foundation
import UIKit
import NMapsMap
import SnapKit


class RegisterLocateSettingView: UIView {
    //상단 숫자
    let numsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = viewNumsColor
        label.textColor = .white
        label.text = "2"
        label.textAlignment = .center
        label.layer.cornerRadius = 16
        label.layer.masksToBounds = true
        return label
    }()

    // 위치 설정 label
    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "위치 설정"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        return label
    }()

    //킥보드 배치 상세설명 label
    let detailLabel: UILabel = {
        let label = UILabel()
        label.text = "킥보드를 배치할 위치를 선택해주세요."
        return label
    }()

    //하단 이전, 다음 컨테이너뷰
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
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 12
        return button
    }()

    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 12
        return button
    }()

    // 배치 위치 검색 컨테이너
    let searchContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    // 배치 위치 label
    let searchLabel: UILabel = {
        let label = UILabel()
        label.text = "배치 위치"
        return label
    }()

    // 배치 서치 textField
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = bgColor
        textField.placeholder = "예: 강남역 2번 출구"
        return textField
    }()

    //배치 위치 확인 버튼
    let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.setTitleColor(.darkGray, for: .normal)
        button.backgroundColor = bgColor
        button.layer.cornerRadius = 12
        return button
    }()

    // 서치한 위치의 지도 나타내는 uiView
    let mapView: NMFMapView = {
        let view = NMFMapView()
        view.moveCamera(NMFCameraUpdate(scrollTo: NMGLatLng(lat: 37.5665, lng: 126.9780)))
        return view
    }()

    // 지도에 표시할 마커
    let marker = NMFMarker()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupLayout()
        setupTargets()
        searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureUI() {
        [numsLabel, infoLabel, detailLabel, searchContainerView, bottomContainerView, mapView].forEach {
            self.addSubview($0)
        }
        [prevButton, nextButton].forEach {
            bottomContainerView.addSubview($0)
        }
        [searchLabel, searchTextField, searchButton].forEach {
            searchContainerView.addSubview($0)
        }
    }

    func setupLayout() {
        numsLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(30)
            $0.width.height.equalTo(32)
            $0.centerX.equalToSuperview()
        }
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(numsLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        detailLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        searchContainerView.snp.makeConstraints {
            $0.top.equalTo(detailLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        mapView.snp.makeConstraints {
            $0.top.equalTo(searchContainerView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomContainerView.snp.top)
        }
        bottomContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.top.equalTo(prevButton.snp.top).offset(-16)
        }
        searchContainerSetUpLayout()
        bottomContainerSetUpLayout()
    }

    func searchContainerSetUpLayout() {
        searchLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(searchLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(60)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(searchTextField)
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(20)
        }
    }

    func bottomContainerSetUpLayout() {
        prevButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalTo(nextButton.snp.leading).offset(-20)
        }
        nextButton.snp.makeConstraints {
            $0.width.equalTo(prevButton)
            $0.centerY.height.equalTo(prevButton)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(prevButton.snp.trailing).offset(20)
        }
    }

    // 다음 버튼 활성화 감시
    private func setupTargets() {
        searchTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nextButton.isEnabled = false
        nextButton.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1)
        nextButton.setTitleColor(.darkGray, for: .normal)
    }

    @objc private func textFieldChanged() {
        let hasText = !(searchTextField.text?.isEmpty ?? true)
        nextButton.isEnabled = hasText
        nextButton.backgroundColor = hasText
            ? UIColor(red: 0.145, green: 0.388, blue: 0.922, alpha: 1)
            : UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1)
        nextButton.setTitleColor(hasText ? .white : .darkGray, for: .normal)
    }

    // Geocoding 검색 기능
    @objc func searchButtonTapped() {
        guard let query = searchTextField.text, !query.isEmpty else {
            print("검색어를 입력해주세요.")
            return
        }
        print("searchButtonTapped query:", query)
        geocode(query: query)
    }

    // Geocoding API 호출 및 지도 이동
    func geocode(query: String) {
        guard let encodeQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://maps.apigw.ntruss.com/map-geocode/v2/geocode?query=\(encodeQuery)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("oj5l1oliar", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue("wndlYwoXCHG0cV6r465Jy502IN1rQZV2hslxhwMm", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let resp = try? JSONDecoder().decode(GeocodingResponse.self, from: data),
                  let first = resp.addresses.first else { return }

            let y = first.y
            let x = first.x
            guard let lat = Double(y), let lng = Double(x) else { return }

            DispatchQueue.main.async {
                self.updateMap(lat: lat, lng: lng)
            }
        }.resume()
    }




    func updateMap(lat: Double, lng: Double) {
        print("updateMap -> lat:", lat, "lng:", lng)

        let latLng = NMGLatLng(lat: lat, lng: lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: latLng)
        cameraUpdate.animation = .fly
        cameraUpdate.animationDuration = 1.0

        DispatchQueue.main.async {
            self.mapView.moveCamera(cameraUpdate)

            if let sym = UIImage(systemName: "mappin.and.ellipse") {
                self.marker.iconImage = NMFOverlayImage(image: sym)
            } else {
                self.marker.iconImage = NMF_MARKER_IMAGE_BLACK
            }
            self.marker.position = latLng
            self.marker.mapView = self.mapView
        }
    }


}

