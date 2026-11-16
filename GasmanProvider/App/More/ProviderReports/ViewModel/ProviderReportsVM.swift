//
//  ProviderReportsVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class ProviderReportsVM: BaseViewModel {

    @Published var generalStats: GeneralStatisticsData?
    @Published var profitStats: [ProfitStatisticsItem] = []

    var selectedTab: StatisticsTab = .general
    var selectedPeriod: StatisticsPeriod = .daily
    var dateFrom: String?
    var dateTo: String?

    func fetchCurrentTab() {
        guard (dateFrom == nil) == (dateTo == nil) else { return }
        switch selectedTab {
        case .general: fetchGeneralStats()
        case .profits: fetchProfitStats()
        }
    }

    private func fetchGeneralStats() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    MoreEndpoints.general(dateFrom: dateFrom, dateTo: dateTo, period: selectedPeriod.rawValue)
                )
                generalStats = result.data
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }

    private func fetchProfitStats() {
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(
                    MoreEndpoints.profits(dateFrom: dateFrom, dateTo: dateTo, period: selectedPeriod.rawValue)
                )
                profitStats = result.data ?? []
                isLoading = false
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
}
