//
//  AppHelper.swift
// NewBase
//
//  Created by MGAbouarab on 30/12/2023.
//

import UIKit
import CoreLocation
import MapKit
import CoreLocation

struct AppHelper {
    
    private init() {}
    
    static func changeWindowRoot(vc: UIViewController, options: UIView.AnimationOptions = .transitionCrossDissolve) {
        UIApplication.shared.windows.first?.rootViewController = vc
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let window = window else {return}
        UIView.transition(with: window, duration: 0.3, options: options, animations: nil, completion: nil)
    }
    

    static func openUrl(_ url: String?) {
        guard let stringUrl = url else {return}
        if let url = URL(string: stringUrl) {
            UIApplication.shared.open(url)
        }
    }
    
    
    static func blockUser() {
        UserDefaults.isLogin = false
        Session.token = nil
        Session.user = nil
        Session.provider = nil
        Session.userType = nil
        UserDefaults.notificationCount = 0
//        DispatchQueue.main.async {
//            UIApplication.shared.applicationIconBadgeNumber = 0
//        }
        let vc = LoginVC(viewModel: LoginVM())
        let nav = BaseNav(rootViewController: vc)
        AppHelper.changeWindowRoot(vc: nav, options: .transitionCurlDown)
    }
    
    static func getAddressFromCoordinates(latitude: Double, longitude: Double, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion("Unknown Location")
                return
            }
            
            if let placemark = placemarks?.first {
                let city = placemark.locality ?? ""
                let area = placemark.subLocality ?? ""
                let country = placemark.country ?? ""
                let address = "\(area), \(city), \(country)"
                completion(address)
            } else {
                completion("Unknown Location")
            }
        }
    }
    
    
    
    static func setupChangeLanguageButton(target: Any, action: Selector) -> UIBarButtonItem{
        let changeLanguageBtn = UIButton(type: .system)
        changeLanguageBtn.layer.masksToBounds = false
        changeLanguageBtn.layer.shadowColor = UIColor.black.cgColor
        changeLanguageBtn.layer.shadowOpacity = 0.1
        changeLanguageBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        changeLanguageBtn.layer.shadowRadius = 4
        changeLanguageBtn.setImage(UIImage(named: "language")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        NSLayoutConstraint.activate([
            changeLanguageBtn.widthAnchor.constraint(equalToConstant: 38),
            changeLanguageBtn.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        changeLanguageBtn.addTarget(target, action: action, for: .touchUpInside)
        return UIBarButtonItem(customView: changeLanguageBtn)
    }
    
    static func setupAppTitle() -> UIBarButtonItem{
        let label = UILabel()
        label.text = "Esterad".localized
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .main
        return UIBarButtonItem(customView: label)
    }
}
