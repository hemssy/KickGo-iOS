import UIKit
import SnapKit

class MainViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.delegate = self
        setupTabs()
        setupTabBarAppearance()
        
    }

    func setupTabs() {
        let mapVC = UINavigationController(rootViewController: MapViewController())
        let registerVC = UINavigationController(rootViewController: RegisterViewController())
        let myVC = UINavigationController(rootViewController: MyViewController())

        // selectedIndex == 0
        mapVC.tabBarItem = UITabBarItem(
            title: "지도",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )
        
        // selectedIndex == 1
        registerVC.tabBarItem = UITabBarItem(
            title: "등록",
            image: UIImage(systemName: "plus.circle"),
            selectedImage: UIImage(systemName: "plus.circle.fill")
        )

        // selectedIndex == 2
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex != 1{
            print("등록탭이 아닌 탭")
            //등록탭에서 다른 곳으로 이동할 때 실제 사용중인 인스턴스에 접근하기
            guard let registerTab = self.viewControllers?[1]  as? UINavigationController else { return }
            guard let registerVC = registerTab.viewControllers.first as? RegisterViewController else { return }
            registerVC.resetRegistrationForm()
        }
    }
}

