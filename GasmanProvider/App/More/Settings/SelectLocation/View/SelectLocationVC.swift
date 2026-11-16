//
//  BookingLocationVC.swift
//  Profix
//
//  Created by Haneen on 11/01/2026.
//

import UIKit
import Combine
import GoogleMaps

class SelectLocationVC: BaseViewController {

    //MARK: - Outlets -
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK: - Properties -
    
    var viewModel : SelectLocationVMProtocol
    
    //MARK: - Initializer -
    
    init(viewModel : SelectLocationVMProtocol){
        self.viewModel = viewModel
        super.init(nibName: "SelectLocationVC", bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle -
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initialConfiguration()
    }
    
    //MARK: - Initial Setup -
    
    func initialConfiguration(){
        self.title = "add_address".localized
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false

        if let initial = viewModel.initialLocation {
            setMapLocation(initial)
        } else {
            AppLocationManager.shared.requestLocation { [weak self] model in
                guard let self = self else { return }
                self.setMapLocation(model)
            }
        }
    }
    
    private func setMapLocation(_ model: AddressModel) {
        let camera = GMSCameraPosition.camera(withLatitude: model.lat,
                                              longitude: model.long,
                                              zoom: 16)

        mapView.animate(to: camera)
        mapView.clear()
        addMarker(model)
        viewModel.selectedAddress = model
        addressLabel.text = model.desc
        addressTextField.text = model.desc
    }
    
    private func addMarker(_ model: AddressModel) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: model.lat, longitude: model.long)
        marker.title = model.desc
        marker.map = mapView
    }
    
    //MARK: - Action -
        
    @IBAction func didTapConfirmAddress(_ sender: UIButton) {
        guard let address = viewModel.selectedAddress else { return }
        guard let addressName = addressTextField.text, !addressName.trimWhiteSpace().isEmpty  else {
            show(errorMessage: ValidationError.emptyAddress.localizedDescription)
            return
        }
        
        viewModel.onLocationSelected?(address)
        pop()
    }
    
    @IBAction func didTapCurrentLocation(_ sender: UIButton) {
        AppLocationManager.shared.requestLocation { [weak self] model in
            guard let self = self else { return }
            self.setMapLocation(model)
        }
    }

}

extension SelectLocationVC: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        AppHelper.getAddressFromCoordinates(latitude: coordinate.latitude , longitude:  coordinate.longitude) { [weak self] model in
            guard let self = self else { return }
            self.mapView.clear()
            self.addMarker(AddressModel(lat: coordinate.latitude, long: coordinate.longitude, desc: model ))
            self.viewModel.selectedAddress = AddressModel(lat: coordinate.latitude, long: coordinate.longitude, desc: model)
            self.addressLabel.text = model
        }
    }
}
