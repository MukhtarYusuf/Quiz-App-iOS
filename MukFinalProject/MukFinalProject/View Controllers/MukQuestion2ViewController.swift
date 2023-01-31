//
//  MukQuestion2ViewController.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/23/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import UIKit

class MukQuestion2ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mukTimeLeftLabel: UILabel!
    @IBOutlet weak var mukQuestionHeaderLabel: UILabel!
    @IBOutlet weak var mukQuestionTextLabel: UILabel!
    @IBOutlet var mukOptionLabels: [UILabel]!
    @IBOutlet var mukOptionSwitches: [UISwitch]!
    
    // MARK: Constants
    let mukQuestionIndex = 1
    
    // MARK: Variables
    var mukTest: MukTest?
    var mukQuestion: MukQuestion?
    
    // MARK: Computed Properties
    var mukFormattedTimeLeft: String {
        let mukTimeLeft = mukTest?.mukTimeLeft ?? 0
        let mukHours = mukTimeLeft/3600
        let mukMins = (mukTimeLeft % 3600) / 60
        let mukSeconds = (mukTimeLeft % 3600) % 60
        
        let mukHoursString = mukHours > 0 ? "\(mukHours)h " : ""
        let mukMinsString = (mukHours != 0 || mukMins != 0) ? "\(mukMins)m " : ""
        let mukSecString = mukSeconds > 0 ? "\(mukSeconds)s" : "0s"
        
        return "\(mukHoursString)\(mukMinsString)\(mukSecString)"
    }
    
    // MARK: Action Methods
    @IBAction func mukChooseOption(_ sender: UISwitch) {
        if let mukChosenIndex = mukOptionSwitches.firstIndex(of: sender) {
            mukQuestion?.mukSelectOption(index: mukChosenIndex)
            updateUI()
        }
    }
    
    @IBAction func mukGoBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Utilities
    func setupUI() {
        mukQuestionHeaderLabel.text = "Question \(mukQuestionIndex+1) of \(mukTest?.mukQuestions.count ?? 0)"
        mukQuestionTextLabel.text = mukQuestion?.mukText
        
        updateUI()
    }
    
    func updateUI() {
        mukUpdateTimeLabel()
        
        for i in 0 ..< mukOptionLabels.count {
            let mukLabel = mukOptionLabels[i]
            let mukSwitch = mukOptionSwitches[i]
            let mukQuestionOption = mukQuestion?.mukOptions[i] ?? ""
            
            mukLabel.text = mukQuestionOption
            
            let mukIsChosen = (mukQuestion?.mukChosenIndex ?? -1) == i
            mukSwitch.setOn(mukIsChosen, animated: true)
        }
    }
    
    @objc func mukUpdateTimeLabel() {
        mukTimeLeftLabel.text = "Time Left: \(mukFormattedTimeLeft)"
        
        guard let mukTest = mukTest else { return }
        if mukTest.mukTimeLeft == 0 && mukTest.mukShouldEnd {
            if let mukResultsVC = storyboard?.instantiateViewController(identifier: "ResultViewController") as? MukResultViewController {
                if let _ = navigationController?.topViewController as? MukResultViewController {
                    // Do Nothing
                } else {
                    mukResultsVC.mukTest = mukTest
                    navigationController?.pushViewController(mukResultsVC, animated: true)
                }
            }
        }
    }

    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NextQuestion3" {
            if let mukQuestion3VC = segue.destination as? MukQuestion3ViewController {
                mukQuestion3VC.mukTest = mukTest
            }
        }
    }
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        mukQuestion = mukTest?.mukQuestions[mukQuestionIndex]
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(mukUpdateTimeLabel),
                                               name: Notification.Name(rawValue: "TimeUpdated"),
                                               object: nil)
            
        setupUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
