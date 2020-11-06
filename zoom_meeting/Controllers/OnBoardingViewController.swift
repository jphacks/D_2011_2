//
//  OnBordingViewController.swift
//  zoom_meeting
//
//  Created by Tommy on 2020/11/06.
//

import UIKit
import paper_onboarding

class OnBoardingViewController: UIViewController {
    
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var startButton: UIButton!
    
    let items = [
        OnboardingItemInfo(informationImage: UIImage(named: "banner")!,
                           title: "aikaへようこそ",
                           description: "aikaはzoomでの会議をより円滑に進めるお手伝いをします。",
                           pageIcon: UIImage(named: "dummy")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white, titleFont: .boldSystemFont(ofSize: 20), descriptionFont: .systemFont(ofSize: 15)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "meeting")!,
                           title: "まずはミーティングを作成しましょう",
                           description: "アプリから簡単にZoomミーティングを作成することができます",
                           pageIcon: UIImage(named: "dummy")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white, titleFont: .boldSystemFont(ofSize: 20), descriptionFont: .systemFont(ofSize: 15)),
        
        OnboardingItemInfo(informationImage: UIImage(named: "agenda_illust")!,
                           title: "会議の議題を登録しましょう",
                           description: "事前に登録された議題に沿ってaikaが会議を円滑に進めるお手伝いをします。",
                           pageIcon: UIImage(named: "dummy")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white, titleFont: .boldSystemFont(ofSize: 20), descriptionFont: .systemFont(ofSize: 15)),
        OnboardingItemInfo(informationImage: UIImage(named: "share")!,
                           title: "会議をシェアしましょう",
                           description: "aikaから作成された会議は議題と一緒にシェアすることができます。",
                           pageIcon: UIImage(named: "dummy")!,
                           color: UIColor(red: 0.40, green: 0.56, blue: 0.71, alpha: 1.00),
                           titleColor: UIColor.white,
                           descriptionColor: UIColor.white, titleFont: .boldSystemFont(ofSize: 20), descriptionFont: .systemFont(ofSize: 15)),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setupPaperOnboardingView()
        skipButton.layer.cornerRadius = 25
        startButton.layer.cornerRadius = 20
        startButton.isHidden = true
        view.bringSubviewToFront(skipButton)
        view.bringSubviewToFront(startButton)
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

extension OnBoardingViewController: PaperOnboardingDataSource {
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        return items[index]
    }
    
    func onboardingItemsCount() -> Int {
        return items.count
    }
}

extension OnBoardingViewController: PaperOnboardingDelegate {
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == items.count - 1 {
            self.skipButton.isHidden = true
            self.startButton.isHidden = false
        } else {
            self.skipButton.isHidden = false
            self.startButton.isHidden = true
        }
    }
}
