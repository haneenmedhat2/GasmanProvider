//
//  ComplaintsModel.swift
//  Esterad
//
//  Created by Haneen on 06/11/2025.
//

import Foundation
import UIKit


struct ComplaintsModel : Codable {
    let subject : String?
    let complaint : String?
    let type : String?
    
    var images: [Data] = []
    
    var uploadData: [UploadData] {
        var files = [UploadData]()
        
        for (index, imageData) in images.enumerated() {
            files.append(
                UploadData(
                    key: "images[\(index)]",
                    data: imageData,
                    mimeType: .jpeg,
                    fileName: "image_\(index)_\(Date().timeIntervalSince1970).jpeg"
                )
            )
        }
        
        return files
    }
}

enum SelectionOptionType : CaseIterable {
    case complaint
    case suggestion
    case electronic
    case cashOnDelivery
    case individual
    case company
    case other
    case receiveOrder
    case returnOrder
    case gasmanApp
    case provider

    var title : String {
        switch self {
        case .complaint:
            return "complaint".localized
        case .suggestion:
            return "suggestion".localized
        case .electronic:
            return "electronic_payment".localized
        case .cashOnDelivery:
            return "cash_on_delivery".localized
        case .individual:
            return "individual".localized
        case .company:
            return "delegate_company".localized
        case .other:
            return "other".localized
        case .receiveOrder:
            return "receive_order".localized
        case .returnOrder:
            return "return_order".localized
        case .gasmanApp:
            return "gasman_app_follower".localized
        case .provider:
            return "provider_follower".localized
        }
    }

    var apiValue : String {
        switch self {
        case .complaint:
            return "complaint"
        case .suggestion:
            return "message"
        case .electronic:
            return "0"
        case .cashOnDelivery:
            return "1"
        case .individual:
            return "0"
        case .company:
            return "1"
        case .other:
            return "2"
        case .receiveOrder:
            return "1"
        case .returnOrder:
            return "2"
        case .gasmanApp:
            return "0"
        case .provider:
            return "1"
        }
    }

    var iconName: String? {
        switch self {
        case .gasmanApp:
            return "gasmanMerchant"
        case .provider:
            return "merchant"
        default:
            return nil
        }
    }
}

struct ComplaintImageItem {
    let image: UIImage
    let data: Data
}
