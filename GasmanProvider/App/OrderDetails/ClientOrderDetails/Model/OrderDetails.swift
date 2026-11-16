//
//  OrderDetails.swift
//  GasMan
//
//  Created by Haneen on 02/03/2026.
//

struct OrderDetails: Codable {
    let id: Int?
    let orderNum: String?
    let date: String?
    let time: String?
    let status: StatusModel?
    let actions: OrderActions?
    let address: Address?
    let financials: Financials?
    let items: [OrderItem]?
    let user: Client?
    let userPhone: String?
    let notes: String?
    let isRated: Bool?
    let isRatedDelegate: Bool?
    let clientRate: MyRates?
    let userRates: [UserRate]?
    let statusBar: [StatusBar]?
    let statusBarImage: String?


    enum CodingKeys: String, CodingKey {
        case id, date, time, status, actions, address, financials, items, user, notes
        case orderNum = "order_num"
        case userPhone = "user_phone"
        case isRated = "is_rated"
        case isRatedDelegate = "is_rated_delegate"
        case clientRate = "client_rate"
        case userRates = "user_rates"
        case statusBar = "status_bar"
        case statusBarImage = "status_bar_image"
    }
    
}
extension OrderDetails {
    
    var isStatusBarHidden : Bool {
        return self.status?.key == 0 ||  self.status?.key == 4
    }
    
    var isDelgateViewHidden : Bool {
        return self.status?.key == 0 ||  self.status?.key == 4
    }
    
    var isTrackButtonHidden : Bool {
        return self.status?.key == 0 ||  self.status?.key == 4
    }
}

struct StatusModel: Codable {
    let key: Int?
    let name: String?
    let title: String?
    let detailsText: String?
    
    enum CodingKeys: String, CodingKey {
        case key
        case name
        case title
        case detailsText = "details_text"
    }
}

struct StatusBar : Codable {
    let selected : String?
    let text : String
}

struct Financials: Codable {
    let address: String?
    let payType: String?
    let payStatus: String?
    let payTypeObj: PayTypeObj?
    let productPrice: String?
    let productsQty: Int?
    let adminCommissionAmount: String?
    let delegateCommissionAmount: String?
    let totalPartialProductsPrice: String?
    let deliveryPrice: String?
    let vatAmount: String?
    let couponValue: String?
    let totalPrice: String?
    let currency: String?
    let totalPriceBeforeDiscount : String?

    enum CodingKeys: String, CodingKey {
        case address
        case payType = "pay_type"
        case payStatus = "pay_status"
        case payTypeObj = "pay_type_obj"
        case productPrice = "product_price"
        case productsQty = "products_qty"
        case adminCommissionAmount = "admin_commission_amount"
        case delegateCommissionAmount = "delegate_commission_amount"
        case totalPartialProductsPrice = "total_partial_products_price"
        case deliveryPrice = "delivery_price"
        case vatAmount = "vat_amount"
        case couponValue = "coupon_value"
        case totalPrice = "total_price"
        case currency
        case totalPriceBeforeDiscount = "total_price_before_discount"
    }
}

struct PayTypeObj: Codable {
    let key: Int?
    let name: String?
    let title: String?
    let detailsText: String?

    enum CodingKeys: String, CodingKey {
        case key, name, title
        case detailsText = "details_text"
    }
}

extension Financials {
    func getDataSource() -> [KeyValueModel] {
        [
            KeyValueModel(title: "delivery_address".localized, value: address),
            KeyValueModel(title: "payment_method".localized, value: payType),
            KeyValueModel(title: "payment_status".localized, value: payStatus),
            KeyValueModel(title: "unit_price".localized,value: productPrice?.toPrice),
            KeyValueModel(title: "subtotal".localized,value: totalPartialProductsPrice?.toPrice),
            KeyValueModel(title: "delivery_price".localized,value: deliveryPrice?.toPrice),
            KeyValueModel(title: "total_price".localized,value: totalPriceBeforeDiscount?.toPrice),
            KeyValueModel(title: "discount_coupon".localized,value: couponValue?.toPrice),
            KeyValueModel(title: "vat".localized,value: vatAmount?.toPrice),
            KeyValueModel(title: "total_after_discount".localized,value: totalPrice?.toPrice)
        ]
    }
}



struct Address: Codable {
    let lat: String?
    let lng: String?
    let mapDesc: String?
    let neighborhood: Neighborhood?
    
    enum CodingKeys: String, CodingKey {
        case lat , lng, neighborhood
        case mapDesc = "map_desc"
    }
}

struct OrderItem: Codable {
    let productId: Int?
    let title: String?
    let productTitle: String?
    let image: String?
    let qty: Int?
    let qtyPrice: String?
    let price: String?
    let totalPrice: String?
    let currency: String?
    let availableToRetrieve: Int?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case title
        case productTitle = "product_title"
        case image
        case qty
        case qtyPrice = "qty_price"
        case price
        case totalPrice = "total_price"
        case currency
        case availableToRetrieve
        case type
    }
}

struct OrderActions: Codable {
    let acceptButton: Bool
    let refuseButton: Bool
    let onWayButton: Bool
    let deliverToCustomerButton: Bool
    let rateClientButton: Bool
    
    enum CodingKeys: String, CodingKey {
        case acceptButton = "accept_button"
        case refuseButton = "refuse_button"
        case onWayButton = "on_way_button"
        case deliverToCustomerButton = "deliver_to_customer_button"
        case rateClientButton = "rate_client_button"
    }
}

struct Client: Codable {
    let id: Int?
    let name: String?
    let image: String?
    
    let lat: String?
    let lng: String?
    let mapDesc: String?
}

struct DelegateModel: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let phone: String?
    let carModel: String?
    let carType: String?
    let vehicleLicensePlate: String?
    let lat: Double?
    let lng: Double?
    let rate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case image
        case phone
        case carModel = "car_model"
        case carType = "car_type"
        case vehicleLicensePlate = "vehicle_license_plate"
        case lat
        case lng
        case rate
    }
}

struct MyRates : Codable {
    let comment : String?
    let id : Int?
    let image : String?
    let name : String?
    let rate : Double?
    let raterableType : String?
    
    enum CodingKeys: String, CodingKey {
        case comment
        case id
        case image
        case name
        case rate
        case raterableType = "raterable_type"
    }
}

struct UserRate: Codable {
    let id: Int?
    let rate: Double?
    let comment: String?
    let text: String?
    let rateable: Rateable?
}

struct Rateable: Codable {
    let id: Int?
    let name: String?
    let image: String?
}

struct CancelReasonModel: Codable {
    let id: Int?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id, title, name
    }

    init(id: Int?, title: String?) {
        self.id = id
        self.title = title
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        title = try container.decodeIfPresent(String.self, forKey: .title)
            ?? container.decodeIfPresent(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(title, forKey: .title)
    }
}

extension CancelReasonModel: SelectionModelPicker {
    var pickerId: Int { id ?? 0 }
    var pickerName: String { title ?? "" }
}

struct CouponModel: Codable {
    let id: Int?
    let name: String?
}

struct RateClientModel {
    let orderId: Int
    let userRate: Int
    let userComment: String
}

struct RateOrderModel: Codable {
    let orderId: Int?
    let orderRate: Int?
    let delegateComment: String?
    let delegateRate: Int?
    let carTypeRate: Int?
    let appRate: Int?
}

struct KeyValueModel{
    var title: String?
    var value: String?
}
