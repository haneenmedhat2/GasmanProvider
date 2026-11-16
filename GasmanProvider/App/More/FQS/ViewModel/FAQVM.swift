//
//  FAQVM.swift
//  Esterad
//
//  Created by Haneen on 10/11/2025.
//

import Foundation
import Combine

final class FAQVM: BaseViewModel {
    
    @Published var faq: BaseResponse<[FAQModel]>?
    
    var faqList : [ExpandableItem] = []
    
    func faqRequest(){
        isLoading = true
        Task {
            do {
                let result = try await getAllRequest(MoreEndpoints.getFaq())
                faqList = convertFAQsToExpandableItems(faqs: result.data ?? [])
                faq = result

                isLoading = false
                
            } catch {
                isLoading = false
                self.error = error
            }
        }
    }
    
    func convertFAQsToExpandableItems(faqs: [FAQModel]) -> [ExpandableItem] {
        return faqs.map { ExpandableItem(faq: $0) }
    }
}
