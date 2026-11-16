//
//  DelegateInfoVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class DelegateInfoVM: BaseViewModel {

    @Published var info: DelegateRequestItem?
    @Published var stats: GeneralStatisticsData?
    @Published var settlement: SettlementCashResponse?
    @Published var settleSuccess: BaseResponse<String>?
    @Published var canAddStorage: Bool = false

    var selectedTab: DelegateInfoTab = .personal
    var selectedPeriod: StatisticsPeriod = .daily
    var dateFrom: String?
    var dateTo: String?

    private let delegateId: Int

    init(delegateId: Int, initialItem: DelegateRequestItem? = nil) {
        self.delegateId = delegateId
        self.info = initialItem
        self.canAddStorage = initialItem?.canAddStorage ?? false
    }

    func fetchInfo() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.providerDelegateShow(id: delegateId))
                if let item = result.data {
                    info = item
                    canAddStorage = item.canAddStorage ?? false
                }
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func toggleStorage() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.providerDelegateToggleStorage(id: delegateId))
                canAddStorage = result.data?.canAddStorage ?? canAddStorage
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func fetchStatistics() {
        guard (dateFrom == nil) == (dateTo == nil) else { return }
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    MoreEndpoints.providerDelegateStatistics(
                        id: delegateId,
                        dateFrom: dateFrom,
                        dateTo: dateTo,
                        period: selectedPeriod.rawValue
                    )
                )
                stats = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func fetchSettlement() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.providerDelegateSettlementSummary(id: delegateId))
                settlement = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    func settle() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.providerDelegateSettle(id: delegateId))
                settleSuccess = result
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
