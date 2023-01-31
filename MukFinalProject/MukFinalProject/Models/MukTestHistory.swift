//
//  MukTestHistory.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/24/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import Foundation

class MukTestHistory {
    
    // MARK: Variables
    var mukTests = [MukTest]()
    
    // MARK: Initializers
    init() {
        mukLoadTests()
    }
    
    // MARK: Instance Methods
    func mukAddAndSave(mukTest: MukTest) -> Bool {
        mukTests.insert(mukTest, at: 0)
        
        return mukSaveTests()
    }
    
    // MARK: Utilities
    func mukDataFilePath() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0].appendingPathComponent("MukTestHistory.plist")
    }
    
    func mukSaveTests() -> Bool {
        var success = true
        let mukEncoder = PropertyListEncoder()
        
        do {
            let data = try mukEncoder.encode(mukTests)
            try data.write(to: mukDataFilePath(), options: .atomic)
        } catch {
            success = false
            print("Error Saving Tests")
        }
        
        return success
    }
    
    func mukLoadTests() {
        if let mukData = try? Data(contentsOf: mukDataFilePath()) {
            let decoder = PropertyListDecoder()
            do {
                mukTests = try decoder.decode([MukTest].self, from: mukData)
            } catch {
                print("Error Loading Tests")
            }
        }
    }

}
