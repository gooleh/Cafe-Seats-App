import UIKit
import MapKit

class MainViewController: UIViewController {
    private let mainView = MainView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "카페 자리있어?"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]
    }
    
    private func setupButtons() {
        mainView.mapButton.addTarget(self, action: #selector(showMap), for: .touchUpInside)
        mainView.listButton.addTarget(self, action: #selector(showList), for: .touchUpInside)
    }
    
    @objc private func showMap() {
        let mapVC = MapViewController()
        navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc private func showList() {
        let listVC = CafeListViewController()
        navigationController?.pushViewController(listVC, animated: true)
    }
}
