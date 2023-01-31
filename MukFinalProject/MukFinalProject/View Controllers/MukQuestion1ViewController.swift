//
//  MukQuestion1ViewController.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/22/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import UIKit

class MukQuestion1ViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mukTimeLeftLabel: UILabel!
    @IBOutlet weak var mukQuestionHeaderLabel: UILabel!
    @IBOutlet weak var mukQuestionTextLabel: UILabel!
    @IBOutlet var mukOptionButtons: [UIButton]!
    
    // MARK: Constants
    let mukQuestionIndex = 0
    
    // MARK: Variables
    var mukTest: MukTest? // Will not Become nil again after setting. Use Implicit unwrap?
    var mukQuestion: MukQuestion? // Will not Become nil again after setting
    
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
    @IBAction func mukChooseOption(_ sender: UIButton) {
        if let mukChosenIndex = mukOptionButtons.firstIndex(of: sender) {
            mukQuestion?.mukSelectOption(index: mukChosenIndex)
            updateUI()
        }
    }
    
    // MARK: Utilities
    func setupUI() { // Called Once
        mukQuestionHeaderLabel.text = "Question \(mukQuestionIndex+1) of \(mukTest?.mukQuestions.count ?? 0)"
        mukQuestionTextLabel.text = mukQuestion?.mukText
        
        updateUI()
    }
    
    @objc func updateUI() { // Called More Than Once
        mukUpdateTimeLabel()
        
        for i in 0 ..< mukOptionButtons.count {
            let mukButton = mukOptionButtons[i]
            let mukQuestionOption = mukQuestion?.mukOptions[i] ?? ""
            
            mukButton.setTitle(mukQuestionOption, for: .normal)
            
            var mukTitleColor: UIColor
            var mukButtonBackgroundColor: UIColor
            if mukQuestion?.mukChosenIndex == i {
                mukTitleColor = UIColor.white
                
                mukButtonBackgroundColor = UIColor(red: 0.0, green: 0.26, blue: 0.43, alpha: 1.0)
            } else {
                mukTitleColor = UIColor(red: 0.0, green: 0.26, blue: 0.43, alpha: 1.0)
                mukButtonBackgroundColor = UIColor.clear
            }
            
            mukButton.backgroundColor = mukButtonBackgroundColor
            mukButton.setTitleColor(mukTitleColor, for: .normal)
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
        if segue.identifier == "NextQuestion2" {
            if let mukQuestion2VC = segue.destination as? MukQuestion2ViewController {
                mukQuestion2VC.mukTest = mukTest
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
