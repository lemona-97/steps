//
//  HealthKitStorage.swift
//  steps
//
//  Created by wooseob on 12/11/23.
//

import HealthKit
/// 건강 데이터 접근
final class HealthKitStorage {
    static let shared = HealthKitStorage()
    
    private let store = HKHealthStore()
    
    //접근할 카테고리
    let read = HKObjectType.quantityType(forIdentifier: .stepCount)!
    let share = HKObjectType.quantityType(forIdentifier: .stepCount)!
    
    func requestAuthorization() {
        self.store.requestAuthorization(toShare: Set([share]), read: Set([read])) { (success, error) in
            if error != nil {
                print(error.debugDescription)
            } else {
                if success {
                    print("권한이 부여되었습니다.")
                }else {
                    print("권한이 아직 없습니다.")
                }
            }
        }
    }
    /// 건강데이터의 걸음수 가져오기
    func getStepCount(completion: @escaping (Double) -> Void) {
        guard let stepQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        print("=====HK=====")
        print("startDate : ", startDate)
        print("now : ", now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            guard let result = result, let sum = result.sumQuantity() else {
                print("fail")
                return
            }
            DispatchQueue.main.async {
                completion(sum.doubleValue(for: HKUnit.count()))
            }
        }
        self.store.execute(query)
    }
}


