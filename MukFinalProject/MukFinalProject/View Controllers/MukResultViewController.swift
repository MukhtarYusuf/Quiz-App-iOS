//
//  MukResultViewController.swift
//  MukFinalProject
//
//  Created by Mukhtar Yusuf on 11/23/20.
//  Copyright © 2020 Mukhtar Yusuf. All rights reserved.
//

import UIKit

class MukResultViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mukEmojiLabel: UILabel!
    @IBOutlet weak var mukResultMessageLabel: UILabel!
    @IBOutlet weak var mukNameLabel: UILabel!
    @IBOutlet weak var mukTimeTakenLabel: UILabel!
    @IBOutlet weak var mukScoreLabel: UILabel!
    @IBOutlet weak var mukScoreRingView: MukRingView!
    @IBOutlet weak var mukSaveScoreButton: UIButton!
    @IBOutlet weak var mukScoreHistoryButton: UIButton!
    @IBOutlet weak var mukTryAgainButton: UIButton!
    
    // MARK: Constants
    let mukTestHistory = MukTestHistory()
    
    // MARK: Variables
    var mukTest: MukTest? // Won't Become nil Again
    
    // MARK: Computed Properties
    var mukEmojiString: String {
        var mukEmoji = ""
        
        let mukCorrectAnswers = mukTest?.mukCorrectCount ?? 0
        if mukCorrectAnswers <= 2 {
            mukEmoji = "🙁"
        } else if mukCorrectAnswers == 3 {
            mukEmoji = "🙂"
        } else if mukCorrectAnswers == 4 {
            mukEmoji = "😁"
        } else {
            mukEmoji = "🤩"
        }
        
        return mukEmoji
    }
    var mukFormattedTimeTaken: String {
        let mukTotalTime = mukTest?.mukTotalTime ?? 0
        let mukTimeLeft = mukTest?.mukTimeLeft ?? 0
        let mukTimeTaken = mukTotalTime - mukTimeLeft
        let mukHours = mukTimeTaken/3600
        let mukMins = (mukTimeTaken % 3600) / 60
        let mukSeconds = (mukTimeTaken % 3600) % 60
        
        let mukHoursString = mukHours > 0 ? "\(mukHours)h " : ""
        let mukMinsString = (mukHours != 0 || mukMins != 0) ? "\(mukMins)m " : ""
        let mukSecString = mukSeconds > 0 ? "\(mukSeconds)s" : "0s"
        
        return "\(mukHoursString)\(mukMinsString)\(mukSecString)"
    }
    
    // MARK: Action Methods
    @IBAction func mukSaveScore(_ sender: UIButton) {
        guard let mukTest = mukTest else { return }
        
        let mukSuccess = mukTestHistory.mukAddAndSave(mukTest: mukTest)
        
        let mukTitle = mukSuccess ? "Success!" : "Failed!"
        let mukAlert = UIAlertController(title: mukTitle, message: nil, preferredStyle: .alert)
        mukAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] action in
            self?.mukSaveScoreButton.isEnabled = false
            self?.performSegue(withIdentifier: "GoToHistory", sender: nil)
        }))
        
        present(mukAlert, animated: true, completion: nil)
    }
    
    @IBAction func mukTryAgain(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Utilities
    private func setupUI() {
        guard let mukTest = mukTest else { return }
        
        mukNameLabel.text = "Name: Mukhtar Yusuf"
        mukEmojiLabel.text = mukEmojiString
        mukResultMessageLabel.text = mukTest.mukResultMessageString
        mukTimeTakenLabel.text = "Time Taken: \(mukFormattedTimeTaken)"
        mukScoreLabel.text = mukTest.mukScoreString
        
        mukScoreRingView.mukRingColor = UIColor(red: 0.0, green: 0.26, blue: 0.43, alpha: 1.0)
        mukScoreRingView.mukRatio = Float(mukTest.mukCorrectCount) / Float(mukTest.mukQuestions.count)
        
        if mukTest.mukShouldTryAgain {
            mukSaveScoreButton.isHidden = true
            mukScoreHistoryButton.isHidden = true
        } else {
            mukTryAgainButton.isHidden = true
        }
    }
    
    // MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        mukTest?.mukTimer.invalidate()
            
        setupUI()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
