//
//  ViewController.swift
//  steps
//
//  Created by wooseob on 12/11/23.
//

import UIKit
import Combine

class ViewController: UIViewController {

    @IBOutlet weak var steps: UILabel!
    @IBOutlet weak var realtimeSteps: UILabel!
    
    private let HKStorage = HealthKitStorage.shared
    private let coreMotion = CoreMotionService.shared
    private var cancelBag = Set<AnyCancellable>()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        HKStorage.requestAuthorization()
        coreMotion.$realtimeStep.sink { step in
            self.realtimeSteps.text = String(step)
        }.store(in: &cancelBag)
    }
    
    
    @IBAction func getStepsCountButton(_ sender: UIButton) {
        HKStorage.getStepCount { steps in
            self.steps.text = String(steps)
        }
    }
    

}

