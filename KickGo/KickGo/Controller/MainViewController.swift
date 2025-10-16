import UIKit
import SnapKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //상단 back버튼 숨김처리
        self.navigationItem.hidesBackButton = true
        setupTabs()
        setupTabBarAppearance()
    }

    func setupTabs() {
        let mapVC = UINavigationController(rootViewController: MapViewController())
        let registerVC = UINavigationController(rootViewController: RegisterViewController())
        let myVC = UINavigationController(rootViewController: MyViewController())

        mapVC.tabBarItem = UITabBarItem(
            title: "지도",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )

        registerVC.tabBarItem = UITabBarItem(
            title: "등록",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )

        myVC.tabBarItem = UITabBarItem(
            title: "마이",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [mapVC, registerVC, myVC]
    }

    func setupTabBarAppearance() {
        tabBar.tintColor = UIColor(red: 0.145, green: 0.388, blue: 0.922, alpha: 1.0) //#2563EB 컬러
        tabBar.unselectedItemTintColor = UIColor.gray
        tabBar.backgroundColor = .systemBackground
    }
}

