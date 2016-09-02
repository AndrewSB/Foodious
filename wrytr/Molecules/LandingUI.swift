import UIKit
import Library
import RxSwift
import RxCocoa
import Cordux

extension Landing {
   
    class UI: UIType {
        let interface: Landing.ViewController.IB
        let handler: Landing.Handler
        
        lazy var bindings: [Disposable] = [
            self.interface.facebookButton.rx.tap.asDriver().drive(onNext: self.handler.facebookTap),
            self.interface.twitterButton.rx.tap.asDriver().drive(onNext: self.handler.twitterTap),
            self.interface.helperButton.rx.tap.asDriver()
                .scan(ViewModel.Option.login) { previousState, _ in
                    switch previousState {
                    case .login: return .register
                    case .register: return .login
                    }
                }
                .drive(onNext: self.handler.changeAuthOptionTap)
        ]
        
        init(interface: ViewController.IB, handler: Handler) {
            self.interface = {
                $0.formContainer.addEdgePadding()
                
                $0.subtitle.text = tr(key: .LoginLandingSubtitle)
                
                $0.titleLabel.text = tr(key: .LoginLandingSocialButtonTitle)
                
                $0.twitterButton.configure(withColor: UIColor(named: .TwitterBlue))
                $0.facebookButton.configure(withColor: UIColor(named: .FacebookBlue))
                
                [$0.usernameField, $0.emailField, $0.passwordField].forEach { field in field.configure() }
                
                $0.termsOfServiceButton.attributize()
                
                $0.helperButton.layer.borderColor = UIColor(named: .LoginLandingBackround).cgColor
                $0.helperButton.layer.borderWidth = 1
                
                return $0
            }(interface)
            
            self.handler = handler
        }
    }
    
}

extension Landing.UI: Renderer {
    typealias ViewModel = Landing.ViewModel

    func render(_ viewModel: Landing.ViewModel) {
        let wordedOption: String
        let helperTitle: String
        switch viewModel.option {
        case .login:
            wordedOption = tr(key: .LoginLandingLoginTitle)
            helperTitle = tr(key: .LoginLandingHelperLoginTitle)
        case .register:
            wordedOption = tr(key: .LoginLandingRegisterTitle)
            helperTitle = tr(key: .LoginLandingHelperRegisterTitle)
        }

        self.interface.formHeader.text = tr(key: L10n.LoginLandingEmailbuttonTitle(wordedOption))
        self.interface.usernameField.isHidden = viewModel.option == .login
        self.interface.actionButton.setTitle(title: wordedOption)
        self.interface.helperButton.setTitle(title: wordedOption)
        self.interface.helperLabel.text = helperTitle
    }
}

fileprivate extension UIButton {
    fileprivate func configure(withColor color: UIColor) {
        let renderedImage = self.imageView!.image!.withRenderingMode(.alwaysTemplate)
        self.setImage(renderedImage, for: .normal)
        self.imageView!.contentMode = .scaleAspectFit
        
        self.tintColor = color
        
        self.layer.borderWidth = 1
        self.layer.borderColor = color.cgColor
    }
    
    fileprivate func attributize() {
        let title = self.titleLabel!.text!
        let range = NSRange.init(ofString: "Terms & Privacy Policy", inString: title)
        
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttributes([NSForegroundColorAttributeName: UIColor(named: .LoginLandingBackround)], range: range)
        self.setAttributedTitle(attributedString, for: .normal)
        
        self.titleLabel!.lineBreakMode = .byWordWrapping
    }
}

fileprivate extension InsettableTextField {
    fileprivate func configure() {
        insetX = 8
        insetY = 5
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        
        layer.cornerRadius = 4
        clipsToBounds = true
    }
}
