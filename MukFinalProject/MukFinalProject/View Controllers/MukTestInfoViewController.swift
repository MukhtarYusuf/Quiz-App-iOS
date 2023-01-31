//
//  MukTestInfoViewController.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/22/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import UIKit

/* Please Note: - Can also make mukTest a Singleton. Not really needed here.
                - We can also restrict access to only questions for QuestionVCs using delegates.
                   This is more complicated and trivial for a small project. Not really needed
*/

class MukTestInfoViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mukStudentNameLabel: UILabel!
    @IBOutlet weak var mukTestNameLabel: UILabel!
    @IBOutlet weak var mukNoOfQuestionsLabel: UILabel!
    @IBOutlet weak var mukTotalTimeLabel: UILabel!
    
    // MARK: Variables
    var mukTest = MukTest()
    
    // MARK: Computed Properties
    var mukFormattedTotalTime: String {
        let mukTotalTime = mukTest.mukTotalTime
        let mukHours = mukTotalTime/3600
        let mukMins = (mukTotalTime % 3600) / 60
        let mukSeconds = (mukTotalTime % 3600) % 60
        
        let mukHoursString = mukHours > 0 ? "\(mukHours)h " : ""
        let mukMinsString = (mukHours != 0 || mukMins != 0) ? "\(mukMins)m " : ""
        let mukSecString = mukSeconds > 0 ? "\(mukSeconds)s" : "0s"
        
        return "\(mukHoursString)\(mukMinsString)\(mukSecString)"
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BeginExam" {
            if let mukQuestion1VC = segue.destination as? MukQuestion1ViewController {
                // mukTest = MukTest()
                mukQuestion1VC.mukTest = mukTest
                mukTest.mukStartTimer()
            }
        }
    }
    
    // MARK: Utilities
    private func setUpUI() {
        // navigationController?.navigationBar.isHidden = true
        
        mukStudentNameLabel.text = "Name: Mukhtar Yusuf"
        mukTestNameLabel.text = "Test: \(mukTest.mukTestName)"
        mukNoOfQuestionsLabel.text = "No. of Questions: \(mukTest.mukQuestions.count)"
        mukTotalTimeLabel.text = "Time Limit: \(mukFormattedTotalTime)"
    }
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        mukTest = MukTest()
    }
    
}
