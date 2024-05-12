import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpVCs()
        setUpTabBar()
    }

    func setUpTabBar() {
        tabBar.backgroundColor = .white

        self.viewControllers?.forEach({
            $0.tabBarItem.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 20.0, weight: .regular)], for: .normal)
        })
        self.tabBar.layer.borderWidth = 0.50
        self.tabBar.layer.borderColor = UIColor.black.cgColor
        self.tabBar.clipsToBounds = true
//        tabBar.shadowImage = UIImage()
        tabBar.clipsToBounds = true
    }

    func setUpVCs() {
        viewControllers = [
            createNavController(for: SearchBookViewController(), title: NSLocalizedString("검색 탭", comment: "")),
            createNavController(for: BookMarkListViewController(), title: NSLocalizedString("담은 책 리스트 탭", comment: "")),
        ]
    }

    private func createNavController(for rootViewController: UIViewController,
                                     title: String) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title

        return navController
    }
}
