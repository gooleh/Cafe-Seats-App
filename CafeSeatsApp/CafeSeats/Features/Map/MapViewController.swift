// Features/Map/MapViewController.swift

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    private let apiClient = APIClient.shared // APIClient 인스턴스
    private var cafes: [Cafe] = [] // API에서 받아온 카페 데이터를 저장할 배열

    override func viewDidLoad() {
        super.viewDidLoad()
        setupMapView()
        setupLocationManager()
        fetchCafes() // 카페 데이터 가져오기
    }

    private func setupMapView() {
        mapView.frame = view.bounds
        view.addSubview(mapView)
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.backgroundColor = .clear

        if #available(iOS 11.0, *) {
            // CustomCafeAnnotationView 등록
            mapView.register(CustomCafeAnnotationView.self,
                forAnnotationViewWithReuseIdentifier:
                    CustomCafeAnnotationView.identifier)
        }
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // 위치 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 고정된 좌표 사용
        let fixedLocation = CLLocationCoordinate2D(
            latitude: 37.448258,
            longitude: 126.658601)

        let region = MKCoordinateRegion(
            center: fixedLocation,
            latitudinalMeters: 5000, // 지도의 범위를 넓혀서 마커가 보이도록 조정
            longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)

        // MKLocalSearch를 통한 카페 검색
        searchCafes(at: fixedLocation)

        // API에서 받아온 카페 데이터 표시
        addCafeAnnotations()

        locationManager.stopUpdatingLocation()
    }

    // MKLocalSearch를 사용하여 주변 카페 검색
    private func searchCafes(at coordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "카페"
        request.region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000)

        if #available(iOS 13.0, *) {
            request.pointOfInterestFilter = MKPointOfInterestFilter(
                including: [.cafe])
        }

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            if let error = error {
                print("Error searching for cafes: \(error)")
                return
            }

            guard let response = response else {
                print("No response")
                return
            }

            DispatchQueue.main.async {
                for item in response.mapItems {
                    self?.addSearchCafeAnnotation(for: item)
                }
            }
        }
    }

    // APIClient를 사용하여 카페 데이터 가져오기
    private func fetchCafes() {
        apiClient.fetchCafes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedCafes):
                    print("Fetched \(fetchedCafes.count) cafes from API")
                    self?.cafes = fetchedCafes
                    self?.addCafeAnnotations() // 카페 어노테이션 추가
                case .failure(let error):
                    print("Error fetching cafes from API: \(error)")
                }
            }
        }
    }

    // API에서 받아온 카페 데이터를 지도에 표시
    private func addCafeAnnotations() {
        print("Adding \(cafes.count) cafe annotations")
        for cafe in cafes {
            print("Cafe: \(cafe.cafeName), Coordinate: (\(cafe.lat), \(cafe.lng))")
            let annotation = CafeAnnotation(cafe: cafe)
            mapView.addAnnotation(annotation)
        }
    }

    // MKLocalSearch 결과를 지도에 표시 (수정된 부분)
    private func addSearchCafeAnnotation(for mapItem: MKMapItem) {
        // MKMapItem을 Cafe 객체로 변환
        let cafe = Cafe(mapItem: mapItem)
        // cafe 배열에 추가 (중복 방지를 위해 필요 시)
        if !cafes.contains(cafe) { // 중복 확인
            cafes.append(cafe)
            // CafeAnnotation 생성 및 추가
            let annotation = CafeAnnotation(cafe: cafe)
            mapView.addAnnotation(annotation)
        }
    }

    // MKMapViewDelegate 메서드
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 사용자 위치 어노테이션은 기본 처리
        if annotation is MKUserLocation {
            return nil
        }

        if let cafeAnnotation = annotation as? CafeAnnotation {
            // CustomCafeAnnotationView를 사용
            let annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: CustomCafeAnnotationView.identifier,
                for: annotation) as! CustomCafeAnnotationView
            annotationView.annotation = cafeAnnotation
            return annotationView
        } else {
            // MKLocalSearch 결과에 대한 처리 (지금은 필요 없음, 모든 카페가 CafeAnnotation으로 처리됨)
            return nil
        }
    }

    // 마커를 탭했을 때 호출되는 메서드
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let cafeAnnotation = view.annotation as? CafeAnnotation {
            // 상세 정보 창을 표시하는 메서드 호출
            showCafeDetail(for: cafeAnnotation.cafe)
        }
    }

    func showCafeDetail(for cafe: Cafe) {
        let detailVC = CafeDetailViewController(cafe: cafe)
        present(detailVC, animated: true, completion: nil)
    }
}
