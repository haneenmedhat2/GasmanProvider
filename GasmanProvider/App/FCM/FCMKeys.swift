//
//  FCMKeys.swift
//  Esterad
//
//  Created by Haneen on 27/10/2025.
//

import Foundation

enum FCMValueKeys: String {
    case id
    case type
    case orderId = "order_id"
    case ticketId = "ticket_id"
    case titleEn = "title_en"
    case titleAr = "title_ar"
    case meesageEn = "message_en"
    case messageAr = "message_ar"
    case senderName = "sender_name"
}

enum NotificationType: String, Codable {
    case deleteNotify = "delete_notify"
    case delete
    case blockNotify = "block_notify"
    case adminNotify = "admin_notify"
    case userWarningNoResponse = "user_warning_no_response"
    case ticketReply = "ticket_reply"
    case ticketInprogress = "ticket_inprogress"
    case rateOrderToProvider = "rate_order_to_provider"
    case rateOrderToDelegate = "rate_order_to_delegate"
    case receiveDueFinancingFromOrder = "receive_due_financing_from_order"
    case providerRefuseReceiveOrder = "provider_refuse_receive_order"
    case providerAcceptReceiveOrder = "provider_accept_receive_order"
    case providerRefuseReturnOrder = "provider_refuse_return_order"
    case providerAcceptReturnOrder = "provider_accept_return_order"
    case finishedProviderOrder = "finished_provider_order"
    case newProviderReturnOrder = "new_provider_return_order"
    case newProviderReceiveOrder = "new_provider_receive_order"
    case deliveredToProviderReturnOrder = "delivered_to_provider_return_order"
    case cancelledProviderOrder = "cancelled_provider_order"
    case delegateJoinRequestToProvider = "delegate_join_request_to_provider"
    case unknown
    case delegateInsuranceExempt = "delegate_insurance_exempt"
    case delegateInsuranceApplied = "delegate_insurance_applied"
    case delegateWorkPlacesEnabled = "delegate_work_places_enabled"
    case delegateWorkPlacesDisabled = "delegate_work_places_disabled"
    case providerStoreUpdateRequestAccepted = "provider_store_update_request_accepted"
    case providerStoreUpdateRequestRejected = "provider_store_update_request_rejected"
    case delegateProfileUpdateRequestAccepted = "delegate_profile_update_request_accepted"
    case delegateProfileUpdateRequestRejected = "delegate_profile_update_request_rejected"
    case delegateLicenseExpiringSoon = "delegate_license_expiring_soon"
    case delegateInsuranceWithdrawalRequestAccepted = "delegate_insurance_withdrawal_request_accepted"
    case delegateInsuranceWithdrawalRequestRejected = "delegate_insurance_withdrawal_request_rejected"
    case providerWalletWithdrawalRequestAccepted = "provider_wallet_withdrawal_request_accepted"
    case providerWalletWithdrawalRequestRejected = "provider_wallet_withdrawal_request_rejected"

    init(from decoder: Decoder) throws {
        let raw = try decoder.singleValueContainer().decode(String.self)
        self = NotificationType(rawValue: raw) ?? .unknown
    }
}
