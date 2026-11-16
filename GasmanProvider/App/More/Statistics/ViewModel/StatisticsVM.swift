//
//  StatisticsVM.swift
//  GasmanProvider
//

import Foundation
import Combine

final class StatisticsVM: BaseViewModel {

    @Published var generalStats: GeneralStatisticsData?

    var selectedPeriod: StatisticsPeriod = .daily
    var dateFrom: String?
    var dateTo: String?

    func fetchGeneralStats() {
        guard (dateFrom == nil) == (dateTo == nil) else { return }
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
}
