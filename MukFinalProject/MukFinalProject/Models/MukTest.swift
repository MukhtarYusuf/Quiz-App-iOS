//
//  MukTest.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/21/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import Foundation

class MukTest: Codable {
    
    // MARK: Constants
    let mukTotalTime: Int
    let mukTestName: String
    
    // MARK: Variables
    var mukQuestions: [MukQuestion]
    var mukTimer: Timer
    var mukTimeLeft: Int
    var mukDate: Date
    var mukShouldEnd: Bool
    
    enum CodingKeys: String, CodingKey {
        case mukTestName
        case mukTotalTime
        case mukQuestions
        case mukTimeLeft
        case mukDate
        case mukShouldEnd
    }
    
    // MARK: Computed Properties
    private lazy var mukQuestionTexts: [String] = {
        return mukGetQuestionTexts()
    }()
    private lazy var mukQuestionOptions: [[String]] = {
        return mukGetQuestionOptions()
    }()
    private lazy var mukQuestionAnswers: [Int] = {
        return mukGetQuestionAnswers()
    }()
    private lazy var mukQuestionBank: [MukQuestion] = {
        return mukGetQuestionBank()
    }()
    var mukCorrectCount: Int {
        mukQuestions.reduce(0) { (result, question) in
            result + (question.mukIsRightAnswer ? 1 : 0)
        }
    }
    var mukScoreString: String {
        return "\(mukCorrectCount)/\(mukQuestions.count)"
    }
    var mukResultMessageString: String {
        var mukMessageString = ""
        
        if mukCorrectCount <= 2 {
            mukMessageString = "Please try Again!"
        } else if mukCorrectCount == 3 {
            mukMessageString = "Good Job!"
        } else if mukCorrectCount == 4 {
            mukMessageString = "Excellent Work!"
        } else {
            mukMessageString = "You're a Genius!"
        }
        
        return mukMessageString
    }
    var mukShouldTryAgain: Bool {
        return mukCorrectCount <= 2
    }
    
    // MARK: Initializers
    init() {
        mukTestName = "iOS Test"
        mukTotalTime = 120
        mukQuestions = [MukQuestion]()
        mukTimer = Timer()
        mukTimeLeft = mukTotalTime
        mukDate = Date()
        mukShouldEnd = true
        
        var mukBankCopy = mukQuestionBank
        for _ in 0 ..< 4 { // Randomly Add Questions Except the Last One
            let mukIndex = Int.random(in: 0 ..< mukBankCopy.count-1)
            mukQuestions.append(mukBankCopy.remove(at: mukIndex))
        }
        mukQuestions.append(mukBankCopy.remove(at: mukBankCopy.count-1)) // Last Question is Always Fixed in Test
    }
    
    required init(from decoder: Decoder) throws {
        let mukValues = try decoder.container(keyedBy: CodingKeys.self)
        
        mukTestName = try mukValues.decode(String.self, forKey: .mukTestName)
        mukTotalTime = try mukValues.decode(Int.self, forKey: .mukTotalTime)
        mukQuestions = try mukValues.decode([MukQuestion].self, forKey: .mukQuestions)
        mukTimeLeft = try mukValues.decode(Int.self, forKey: .mukTimeLeft)
        mukDate = try mukValues.decode(Date.self, forKey: .mukDate)
        mukShouldEnd = try mukValues.decode(Bool.self, forKey: .mukShouldEnd)
        
        mukTimer = Timer()
    }
    
    deinit {
        mukTimer.invalidate()
    }
    
    // MARK: Instance Methods
    func mukStartTimer() {
        mukTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.mukTimeLeft > 0 {
                self.mukTimeLeft -= 1
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "TimeUpdated"), object: nil)
            }
        }
    }
    
    // MARK: Utilities
    private func mukGetQuestionTexts() -> [String] {
        let mukTexts = [
            "Which is the Name of the Super Class of UITableView?",
            "Which of the Following is True About Delegate Properties?",
            "Which of the Following is True About Classes and Structs?",
            "How is Memory Managed in iOS?",
            "Which of the Following is True About Making a Networking Request in iOS?",
            "In Swift, Arrays are:",
            "The Value of the Slider Taught in Class is Which Data Type?",
            "UITableView gets its Data Through Which Protocol?",
            "Which of the Following is True About Optionals?",
            "Which of the Follwing is the Icon for the XCode IDE?"
        ]
        
        return mukTexts
    }
    
    private func mukGetQuestionOptions() -> [[String]] {
        let mukOptions = [
            ["A. UIScrollView", "B. UIButton", "C. UIViewController", "D. UIView"],
            ["A. They should be unowned", "B. They should be declared weak", "C. They should be declared strong", "D. None of the above"],
            ["A. Both can be subclassed", "B. None can be subclassed", "C. Classes can be subclassed", "D. Both are reference types"],
            ["A. Garbage collection", "B. Automatic value counting", "C. Manually by the developer", "D. Automatic reference counting"],
            ["A. It should be on the main thread", "B. It should be on the UI thread", "C. Should be synchronous", "D. Should be asynchronous"],
            ["A. Classes", "B. Structs", "C. Enums", "D. Protocols"],
            ["A. Int", "B. String", "C. Float", "D. Double"],
            ["A. dataGetter", "B. dataAdapter", "C. delegate", "D. dataSource"],
            ["A. They are never nil", "B. Must always start as nil", "C. Must be unwrapped to use", "D. Must have a value"],
            ["Xcode", "Android Studio", "Visual Studio", "Eclipse"]
        ]
        
        return mukOptions
    }
    
    private func mukGetQuestionAnswers() -> [Int] {
        return [0, 1, 2, 3, 3, 1, 2, 3, 2, 0]
    }
    
    private func mukGetQuestionBank() -> [MukQuestion] {
        let mukCount = mukQuestionTexts.count
        var mukAllQuestions = [MukQuestion]()
        
        for i in 0 ..< mukCount {
            let mukText = mukQuestionTexts[i]
            let mukOptions = mukQuestionOptions[i]
            let mukAnswer = mukQuestionAnswers[i]
            
            let mukQuestion = MukQuestion(mukText: mukText, mukOptions: mukOptions, mukAnswerIndex: mukAnswer)
            mukAllQuestions.append(mukQuestion)
        }
        
        return mukAllQuestions
    }

}
