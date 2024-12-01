// Features/List/CafeListViewController.swift

import UIKit
import MapKit

extension Notification.Name {
    static let cafesUpdated = Notification.Name("cafesUpdated")
}

class CafeListViewController: UIViewController {
    private let tableView = UITableView()
    private var cafes: [Cafe] = []
    private let apiClient = APIClient.shared
    private let fixedCoordinate = CLLocationCoordinate2D(latitude: 37.448258, longitude: 126.658601)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.Colors.background
        setupTableView()
        fetchCafes()
        NotificationCenter.default.addObserver(self, selector: #selector(handleCafesUpdated), name: .cafesUpdated, object: nil)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CafeCell.self, forCellReuseIdentifier: "CafeCell")
        tableView.backgroundColor = Theme.Colors.background
        tableView.separatorStyle = .none
    }

    private func fetchCafes() {
        apiClient.fetchCafes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCafes):
                    self?.cafes = fetchedCafes
                    self?.fetchNearbyCafes()
                case .failure:
                    self?.showErrorAlert(message: "카페 데이터를 불러오는 데 실패했습니다.")
                }
            }
        }
    }

    private func fetchNearbyCafes() {
        searchNearbyCafes { [weak self] nearbyCafes in
            DispatchQueue.main.async {
                guard let self = self else { return }
                let existingCafeIds = Set(self.cafes.map { $0.cafeId })
                let uniqueNearbyCafes = nearbyCafes.filter { !existingCafeIds.contains($0.cafeId) }
                self.cafes.append(contentsOf: uniqueNearbyCafes)
                self.tableView.reloadData()
            }
        }
    }

    private func searchNearbyCafes(completion: @escaping ([Cafe]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "카페"
        request.region = MKCoordinateRegion(center: fixedCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)

        if #available(iOS 13.0, *) {
            request.resultTypes = .pointOfInterest
            request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.cafe])
        }

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error {
                print("Error searching for cafes: \(error)")
                completion([])
                return
            }

            guard let mapItems = response?.mapItems else {
                completion([])
                return
            }

            let nearbyCafes = mapItems.map { Cafe(mapItem: $0) }
            completion(nearbyCafes)
        }
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    @objc private func handleCafesUpdated() {
        fetchCafes()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CafeListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cafes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CafeCell", for: indexPath) as! CafeCell
        cell.configure(with: cafes[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cafe = cafes[indexPath.row]
        let detailVC = CafeDetailViewController(cafe: cafe)
        present(detailVC, animated: true)  // navigationController?.pushViewController 대신 present 사용
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
