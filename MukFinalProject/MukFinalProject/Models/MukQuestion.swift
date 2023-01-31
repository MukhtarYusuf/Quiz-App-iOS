//
//  MukQuestion.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/21/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import Foundation

class MukQuestion: Codable {
    
    // MARK: Constants
    private let mukAnswerIndex: Int
    
    // MARK: Variables
    var mukText: String
    var mukOptions: [String]
    private(set) var mukChosenIndex: Int?
    
    // MARK: Computed Properties
    var mukIsRightAnswer: Bool {
        return mukAnswerIndex == mukChosenIndex
    }
    
    // MARK: Initializers
    init(mukText: String, mukOptions: [String], mukAnswerIndex: Int) {
        self.mukText = mukText
        self.mukOptions = mukOptions
        self.mukAnswerIndex = mukAnswerIndex
    }
    
    #warning("Remove print")
    // MARK: Instance Methods
    func mukSelectOption(index: Int) {
        if index >= 0 && index < mukOptions.count {
            if index == mukChosenIndex { // Deselect if index is the Same as Already Chosen
                mukChosenIndex = nil
            } else {
                mukChosenIndex = index
            }
            print("Is right answer: \(mukIsRightAnswer)")
        }
    }
    
}
