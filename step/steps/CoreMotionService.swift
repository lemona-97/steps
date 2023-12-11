//
//  CoreMotionService.swift
//  steps
//
//  Created by wooseob on 12/11/23.
//

import CoreMotion
import Combine
final class CoreMotionService {
    static let shared = CoreMotionService()
    
    private var pedoMeter = CMPedometer()
    @Published var realtimeStep : Int = 0
    var cancelBag = Set<AnyCancellable>()
    private init() {
        // 3초마다 걸음수 가져오기
        Timer.scheduledTimer(timeInterval: 3.0,
                             target: self,
                             selector: #selector(checkSteps),
                             userInfo: nil,
                             repeats: true)
    }
    
    @objc
    private func checkSteps() {
        let nowDate = Date()
        guard let todayStartDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: nowDate) else {
             return
        }
        print("===CoreMotion===")
        print("UTCTime : ")
        print("todayStartDate : ", todayStartDate)
        print("nowDate :  ", nowDate)
        /// 실시간 걸음수 데이터 가져오기
        pedoMeter.queryPedometerData(from: todayStartDate, to: nowDate) { data, error in
                    if let error {
                        print("CoreMotionService.queryPedometerData Error: \(error)")
                        return
                    }
                    
                    if let steps = data?.numberOfSteps {
                        DispatchQueue.main.async {
                            self.realtimeStep = Int(truncating: steps)
                        }
                    }
                }
    }
}
