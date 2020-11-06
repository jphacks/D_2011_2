//
//  OnBordingViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/06.
//

import UIKit
import paper_onboarding

class OnBordingViewController: UIViewController {
    
    @IBOutlet var skipButton: UIButton!
    
    let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "banner")!,
                           title: "aikaへようこそ",
                           description: "aikaはzoomでの会議をより円滑に進めるお手伝いをします。",
                           pageIcon: UIImage(named: "dummy")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white, titleFont: .boldSystemFont(ofSize: 20), descriptionFont: .systemFont(ofSize: 15)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "banner")!,
                           title: "aikaへようこそ",
                           description: "aikaはzoomでの会議をより円滑に進めるお手伝いをします。",
                           pageIcon: UIImage(named: "dummy")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white, titleFont: .boldSystemFont(ofSize: 20), descriptionFont: .systemFont(ofSize: 15)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "banner")!,
                           title: "aikaへようこそ",
                           description: "aikaはzoomでの会議をより円滑に進めるお手伝いをします。",
                           pageIcon: UIImage(named: "dummy")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white, titleFont: .boldSystemFont(ofSize: 20), descriptionFont: .systemFont(ofSize: 15)),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.isHidden = true
        skipButton.layer.cornerRadius = 25
        setupPaperOnboardingView()
        view.bringSubviewToFront(skipButton)
    }
    
    private func setupPaperOnboardingView() {
        let onboarding = PaperOnboarding()
        onboarding.delegate = self
        onboarding.dataSource = self
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(onboarding)
        for attribute: NSLayoutConstraint.Attribute in [.left, .right, .top, .bottom] {
            let constraint = NSLayoutConstraint(item: onboarding,
                                                attribute: attribute,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: attribute,
                                                multiplier: 1,
                                                constant: 0)
            view.addConstraint(constraint)
        }
    }
    
    @IBAction func skip() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OnBordingViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
}
