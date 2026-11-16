//
//  MoreEndPoints.swift
//  Waraqa
//
//  Created by Haneen on 21/08/2025.
//

import Foundation
import Alamofire


struct MoreEndpoints {
    private init() {}
}

extension MoreEndpoints {
    
    //MARK: - Profile -
    
    static func profile() -> Endpoint<BaseResponse<User>>{
        return .init(
            method: .get,
            path: "delegate/profile",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func providerProfile() -> Endpoint<BaseResponse<Provider>> {
        return .init(
            method: .get,
            path: "provider/profile",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func updateProviderProfile(model: UpdateProviderProfileModel) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/update-provider-store",
            body: [
                "name": model.name,
                "store_name": model.storeName,
                "email": model.email,
                "commercial_number": model.commercialNumber,
                "commercial_end_date": model.commercialEndDate,
                "city_id": model.cityId,
                "lat": model.lat,
                "lng": model.lng,
                "map_desc": model.mapDesc,
                "permission_end_date": model.permissionEndDate,
                "bank_name": model.bankName,
                "bank_account_number": model.bankAccountNumber,
                "iban": model.iban,
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: model.uploadData
        )
    }
    
    static func updateProfile(model: UpdateProfileModel) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/update-profile",
            
            body: [
                "first_name": model.firstName,
                "last_name": model.lastName,
                "email": model.email,
                "identity_number": model.identityNumber,
                "city_id": model.cityId,
                "car_type_id": model.carTypeId,
                "car_model_id": model.carModelId,
                "vehicle_license_plate": model.vehicleLicensePlate,
                "vehicle_serial_number": model.vehicleSerialNumber,
                "lat": model.lat,
                "lng": model.lng,
                "map_desc": model.mapDesc,
                
                "delegate_dates": [
                    "identity_number_end_date": model.identityNumberEndDate,
                    "driver_identity_end_date": model.driverIdentityEndDate,
                    "vehicle_operating_license_end_date": model.vehicleOperatingLicenseEndDate,
                    "identity_image_end_date": model.identityImageEndDate,
                    "vehicle_registration_license_date": model.vehicleRegistrationLicenseDate,
                    "driving_license_end_date": model.drivingLicenseEndDate,
                    "vehicle_insurance_end_date": model.vehicleInsuranceEndDate,
                    "periodic_check_up_date": model.periodicCheckUpDate
                ],

                "image": model.image,
                "identity_image": model.identityImage,
                "driver_identity_image": model.driverIdentityImage,
                "vehicle_operating_license_image": model.vehicleOperatingLicenseImage,
                "driving_license_image": model.drivingLicenseImage,
                "vehicle_registration_license_image": model.vehicleRegistrationLicenseImage,
                "vehicle_insurance_image": model.vehicleInsuranceImage,
                "periodic_check_up_image": model.periodicCheckUpImage,
                "other_image": model.otherImage,
                "vehicle_front_image": model.vehicleFrontImage,
                "vehicle_back_image": model.vehicleBackImage,
                "vehicle_right_image": model.vehicleRightImage,
                "vehicle_left_image": model.vehicleLeftImage,
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    //MARK: - Settings -
    
    static func sendCurrentPhoneCode() -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/change-phone-old-phone-send-code",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func changeOldPhoneCheckCode(code : String) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/change-phone-old-phone-check-code",
            body : [
                "code" : code
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func resendPhoneCode(type : Int) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/change-phone-re-send-code",
            body: [
                "type" : type
            ],
            headerType: .authorized(token: Session.token ?? ""),
        )
    }

    static func sendCodeNewPhone(phone : String) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/change-phone-new-phone-send-code",
            body: [
                "country_code" : "966",
                "phone" : phone
            ],
            headerType: .authorized(token: Session.token ?? ""),
        )
    }

    static func newPhoneCheckCode(code : String , phone : String) -> Endpoint<BaseResponse<User>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/change-phone-new-phone-check-code",
            body: [
                "country_code" : "966",
                "phone" : phone,
                "code" : code
            ],
            headerType: .authorized(token: Session.token ?? ""),
        )
    }
    
    static func changePassword(model:ChangePasswordModel) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .patch,
            path: "\(prefix)/update-password",
            body: [
                "old_password": model.currentPassword,
                "password" : model.password,
                "password_confirmation" : model.passwordConfirmation
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func switchNotification() -> Endpoint<BaseResponse<SwitchNotification>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .patch,
            path: "\(prefix)/switch-notify",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func changeLanguage(lang: String) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .patch,
            path: "\(prefix)/change-lang?lang=\(lang)",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func deleteAccount(deviceId: String) -> Endpoint<BaseResponse<String>>{
        let isProvider = Session.userType == .serviceProvider
        let prefix = isProvider ? "provider" : "delegate"
        let method: HTTPMethod = isProvider ? .delete : .post
        return .init(
            method: method,
            path: "\(prefix)/delete-account?\(deviceId)",
//            queries: [
//                "device_id": deviceId
//            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    //MARK: - Wallet -
    
    static func showWallet() -> Endpoint<BaseResponse<WalletResponse>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/show-wallet",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func chargeWallet( amount: Double) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/charge-wallet",
            body: ["amount" : amount],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func withdrawMoney(model: WithdrawMoney) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/send-withdraw-request",
            body: [
                "amount" : model.amount,
                "bank_name" : model.bankName,
                "bank_account_number" : model.bankAccountNumber,
                "iban" : model.iban,
                "type" : model.type,
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    //MARK: - Static Pages -
    
    static func aboutUs() -> Endpoint<BaseResponse<StaticPagesModel>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/about"
        )
    }
    
    static func termsAndConditions() -> Endpoint<BaseResponse<StaticPagesModel>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/terms"
        )
    }
    
    static func privacyPolicy() -> Endpoint<BaseResponse<StaticPagesModel>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/privacy"
        )
    }
    
    static func getFaq() -> Endpoint<BaseResponse<[FAQModel]>>{
        return .init(
            method: .get,
            path: "get-fqss"
        )
    }
    
    static func sendComplaints(model : ComplaintsModel) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        let uploads = Session.userType == .serviceProvider ? [] : model.uploadData
        return .init(
            method: .post,
            path: "\(prefix)/store-complaint",
            body: [
                "subject" : model.subject,
                "complaint" : model.complaint,
                "type" : model.type
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: uploads

        )
    }
    
    static func contactUsData() -> Endpoint<BaseResponse<ContactUsDataResponse>> {
        return .init(
            method: .get,
            path: "contact-us-data"
        )
    }

    static func contactUs(model: ContactUsModel) -> Endpoint<BaseResponse<String>> {
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/send-contact-message",
            body: [
                "user_name " : model.name,
                "email" : model.email,
                "subject" : model.subject
            ],
            headerType: .authorized(token: Session.token ?? ""),
            uploads: model.uploadData
        )
    }
    
    static func getReviews() -> Endpoint<BaseResponse<ReviewsResponse>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/my-ratings",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func signout(deviceId: String) -> Endpoint<BaseResponse<String>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .delete,
            path: "\(prefix)/sign-out",
            body: [
                "device_id": deviceId
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func switchReceivingOrders() -> Endpoint<BaseResponse<Bool>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/switch-receiving-order-status",
            body: [
                "_method": "patch"
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    //MARK: - Insurance -
    
    static func showInsurance() -> Endpoint<BaseResponse<InsuranceResponse>> {
        return .init(
            method: .get,
            path: "delegate/show-insurance",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func chargeInsurance(cylinders: [[String: Any]]) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "delegate/charge-insurance",
            body: ["cylinders": cylinders],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    //MARK: - Work Places -
    
    static func getWorkPlaces() -> Endpoint<BaseResponse<NeighborhoodsResponse>>{
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/work-places",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func toggleWorkPlaces(neighborhoodIds: [Int]) -> Endpoint<BaseResponse<String>> {
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/work-places/toggle",
            body: [
                "neighborhood_ids": neighborhoodIds
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    //MARK: - Statistics -
    
    static func general(dateFrom: String?, dateTo: String?, period: String) -> Endpoint<BaseResponse<GeneralStatisticsData>> {
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        var queries: [String: Any] = ["period": period]
        if let from = dateFrom { queries["date_from"] = from }
        if let to = dateTo { queries["date_to"] = to }
        return .init(
            method: .get,
            path: "\(prefix)/statistics/general",
            queries: queries,
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func profits(dateFrom: String?, dateTo: String?, period: String) -> Endpoint<BaseResponse<[ProfitStatisticsItem]>> {
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        var queries: [String: Any] = ["period": period]
        if let from = dateFrom { queries["date_from"] = from }
        if let to = dateTo { queries["date_to"] = to }
        return .init(
            method: .get,
            path: "\(prefix)/statistics/profits",
            queries: queries,
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    //MARK: - Provider Invoices -

    static func customerInvoices(page: Int = 1) -> Endpoint<BaseResponse<InvoiceListResponse>> {
        return .init(
            method: .get,
            path: "provider/invoices/customer",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func providerInvoices(page: Int = 1) -> Endpoint<BaseResponse<InvoiceListResponse>> {
        return .init(
            method: .get,
            path: "provider/invoices/provider",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func invoiceDetails(id: Int) -> Endpoint<BaseResponse<InvoiceDetails>> {
        return .init(
            method: .get,
            path: "provider/invoices/\(id)/show",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    //MARK: - Provider Home (Delegates) -

    static func providerDelegates(page: Int = 1) -> Endpoint<BaseResponse<DelegateRequestsResponse>> {
        return .init(
            method: .get,
            path: "provider/delegates",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func providerDelegateShow(id: Int) -> Endpoint<BaseResponse<DelegateRequestItem>> {
        return .init(
            method: .get,
            path: "provider/delegates/\(id)/show",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func providerDelegateToggleStorage(id: Int) -> Endpoint<BaseResponse<ToggleStorageData>> {
        return .init(
            method: .post,
            path: "provider/delegates/\(id)/toggle-storage-permission",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func providerDelegateStatistics(id: Int, dateFrom: String?, dateTo: String?, period: String) -> Endpoint<BaseResponse<GeneralStatisticsData>> {
        var queries: [String: Any] = ["period": period]
        if let from = dateFrom { queries["date_from"] = from }
        if let to = dateTo { queries["date_to"] = to }
        return .init(
            method: .get,
            path: "provider/delegates/\(id)/statistics",
            queries: queries,
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func providerDelegateSettlementSummary(id: Int) -> Endpoint<BaseResponse<SettlementCashResponse>> {
        return .init(
            method: .get,
            path: "provider/delegates/\(id)/settlement-summary",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func providerDelegateSettle(id: Int) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/delegates/\(id)/settle",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    //MARK: - Delegate Requests -

    static func delegateRequests(page: Int = 1) -> Endpoint<BaseResponse<DelegateRequestsResponse>> {
        return .init(
            method: .get,
            path: "provider/delegate-requests",
            queries: ["page": page],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func delegateRequestShowInfo(id: Int) -> Endpoint<BaseResponse<User>> {
        return .init(
            method: .get,
            path: "provider/delegate-requests/\(id)/show-info",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func approveDelegateRequest(id: Int) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/delegate-requests/\(id)/approve",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func rejectDelegateRequest(id: Int) -> Endpoint<BaseResponse<String>> {
        return .init(
            method: .post,
            path: "provider/delegate-requests/\(id)/reject",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    //MARK: - Settlement -

    static func settlementCashReceived() -> Endpoint<BaseResponse<SettlementCashResponse>> {
        return .init(
            method: .get,
            path: "delegate/settlement-cash-received",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    //MARK: - Tutorial Video -

    static func seenTutorialVideo() -> Endpoint<BaseResponse<String>> {
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .post,
            path: "\(prefix)/seen-tutorial-video",
            body: ["_method": "patch"],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func tutorialVideo() -> Endpoint<BaseResponse<TutorialVideoModel>> {
        let prefix = Session.userType == .serviceProvider ? "provider" : "delegate"
        return .init(
            method: .get,
            path: "\(prefix)/tutorial-video",
            headerType: .authorized(token: Session.token ?? "")
        )
    }
    
    static func storage() -> Endpoint<BaseResponse<StorageResponse>> {
        return .init(
            method: .get,
            path: "delegate/storage/index",
            headerType: .authorized(token: Session.token ?? "")
        )
    }

    static func updateStorage(steelFullQty: Int, fiberFullQty: Int) -> Endpoint<BaseResponse<StorageUpdateResponse>> {
        return .init(
            method: .post,
            path: "delegate/storage/update",
            body: [
                "steel_full_qty": steelFullQty,
                "fiber_full_qty": fiberFullQty
            ],
            headerType: .authorized(token: Session.token ?? "")
        )
    }

}
