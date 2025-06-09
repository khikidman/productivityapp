//
//  HabitCategorizer.swift
//  Productivity
//
//  Created by Khi Kidman on 5/28/25.
//

import Foundation
import CoreML

class HabitCategorizer {
    private let model: HabitClassifier
    
    init() {
        self.model = try! HabitClassifier(configuration: MLModelConfiguration())
    }
    
    func categorize(habitText: String) -> String {
        guard let prediction = try? model.prediction(text: habitText) else {
            return "Uncategorized"
        }
        return prediction.label
    }
}
