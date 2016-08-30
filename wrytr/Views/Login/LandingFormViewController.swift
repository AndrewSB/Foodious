//
//  LandingFormViewController.swift
//  wrytr
//
//  Created by Andrew Breckenridge on 5/4/16.
//  Copyright © 2016 Andrew Breckenridge. All rights reserved.
//

import UIKit

import Library

import RxSwift
import RxCocoa

import ReSwift

import SafariServices

class LandingFormViewController: RxViewController {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var socialContainerStackView: UIStackView!
    @IBOutlet weak var twitterSignup: RoundedButton! {
        didSet {
            twitterSignup.setTitle(tr(.LoginLandingTwitterbuttonTitle))
            
            twitterSignup.setImage(twitterSignup.imageView!.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            twitterSignup.tintColor = UIColor(named: .TwitterBlue)
            twitterSignup.imageView!.contentMode = .ScaleAspectFit

            twitterSignup.layer.borderWidth = 1
            twitterSignup.layer.borderColor = UIColor(named: .TwitterBlue).CGColor
        }
    }
    @IBOutlet weak var facebookSignup: RoundedButton! {
        didSet {
            facebookSignup.setTitle(tr(.LoginLandingFacebookbuttonTitle))
            
            facebookSignup.setImage(facebookSignup.imageView!.image!.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            facebookSignup.tintColor = UIColor(named: .FacebookBlue)
            facebookSignup.imageView!.contentMode = .ScaleAspectFit
            
            facebookSignup.layer.borderWidth = 1
            facebookSignup.layer.borderColor = UIColor(named: .FacebookBlue).CGColor
        }
    }
    
    @IBOutlet weak var textOne: InsettableTextField! {
        didSet { styleTextField(textOne) }
    }
    @IBOutlet weak var textTwo: InsettableTextField!{
        didSet { styleTextField(textTwo) }
    }
    @IBOutlet weak var textThree: InsettableTextField!{
        didSet { styleTextField(textThree) }
    }
    
    @IBOutlet weak var tosAndRegisterStackView: UIStackView! {
        didSet {
            tosAndRegisterStackView.addEdgePadding(44)
        }
    }
    @IBOutlet weak var tosButton: UIButton! {
        didSet {
            let title = tosButton.titleLabel!.text!
            let range = NSRange.init(ofString: "Terms & Privacy Policy", inString: title)
            
            let attributedString = NSMutableAttributedString(string: title)
            attributedString.addAttributes([NSForegroundColorAttributeName: UIColor(named: .loginLandingBackround)], range: range)
            
            self.tosButton.titleLabel!.lineBreakMode = .byWordWrapping
            UIView.performWithoutAnimation {
                self.tosButton.setAttributedTitle(attributedString, for: UIControlState())
            }
        }
    }
    @IBOutlet weak var actionButton: RoundedButton!
    
    @IBOutlet weak var loginSignupTitle: UILabel!
    @IBOutlet weak var loginSignupButton: RoundedButton! {
        didSet {
            loginSignupButton.layer.borderColor = UIColor(named: .LoginLandingBackround).CGColor
            loginSignupButton.layer.borderWidth = 1
        }
    }
    
    var state: State?
}

extension LandingFormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookSignup.rx_tap
            .map { self.parentViewController!.startLoading(.grayColor()) }
            .subscribeNext {
                store.dispatch(AuthenticationProvider.loginWithFacebook)
            }
            .addDisposableTo(disposeBag)
        
        twitterSignup.rx_tap
            .map { self.parentViewController!.startLoading(.grayColor()) }
            .subscribeNext {
                store.dispatch(AuthenticationProvider.loginWithTwitter)
            }
            .addDisposableTo(disposeBag)
        
        actionButton.rx_tap
            .map { _ -> AuthenticationProvider.Params in
                let loginParams = AuthenticationProvider.Params.Login(
                    email: self.textTwo.text ?? "",
                    password: self.textThree.text ?? ""
                )
                
                let signupParams = AuthenticationProvider.Params.Signup(name: self.textOne.text ?? "", loginParams: loginParams)
                
                switch self.state! {
                case .Login:
                    return loginParams
                case .Signup:
                    return signupParams
                }
            }
            .subscribeNext { authParams in
                store.dispatch(AuthenticationProvider.authWithFirebase(authParams))
            }
            .addDisposableTo(disposeBag)
        
        loginSignupButton.rx_tap.scan(State.Login) { (previousState, _) -> State in
                previousState == .Login ? .Signup : .Login
            }
            .map(NewLandingState.init)
            .subscribeNext { store.dispatch($0) }
            .addDisposableTo(disposeBag)
        
        tosButton.rx_tap
            .subscribeNext {
                let sVC = SFSafariViewController(URL: NSURL(string: "https://google.com")!)
                self.presentViewController(sVC, animated: true, completion: nil)
            }
            .addDisposableTo(disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [textOne, textTwo, textThree].forEach(styleTextField)
    }
}

extension LandingFormViewController: StoreSubscriber {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        store.subscribe(self) { state in state.authenticationState.landingState }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        store.unsubscribe(self)
    }

    func newState(_ state: State) {
        self.state = state
        textOne.hidden = state == .Login
        
        actionButton.setTitle("\(state.rawValue)", forState: .Normal)
        
        loginSignupButton.setTitle(state.not.rawValue, forState: .Normal)
        titleLabel.text = "\(state.rawValue) with Email"
        loginSignupTitle.text = state == .Login ? "Haven't registered yet?" : "Already registered?"
    }
    
    enum State: String {
        case Login
        case Signup
        
        var not: State {
            switch self {
            case .Login:
                return .Signup
            case .Signup:
                return .Login
            }
        }
    }
    
}

extension LandingFormViewController {
    
    fileprivate func styleTextField(_ tF: InsettableTextField) {
        tF.insetX = 8
        tF.insetY = 5
        
        tF.layer.borderWidth = 1
        tF.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        tF.layer.cornerRadius = 5
        tF.clipsToBounds = true
    }
    
}
