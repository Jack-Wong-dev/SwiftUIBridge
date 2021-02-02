//
//  ViewController.swift
//  SwiftUIBridge
//
//  Created by Jack Wong on 2/1/21.
//

import UIKit
import SwiftUI
import SnapKit

class ViewController: UIViewController {
    
    //MARK: - ViewModel
    private var breathingViewModel = BreathViewModel()
    
    //MARK: - UI Controls
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fill
        sv.spacing = 10
        sv.axis = .vertical
        sv.addAllSubviews(breatheView, playOrPauseButton, pushButton, dataTextField, searchButton)
        return sv
    }()
    
    private lazy var pushButton: UIButton = {
        let b = UIButton()
        b.setTitle("Tap here to see hearts", for: .normal)
        b.backgroundColor = .systemOrange
        b.tintColor = .systemPurple
        b.layer.cornerRadius = 10.0
        b.layer.shadowRadius = 10.0
        b.addTarget(self, action: #selector(pushToHeartsDemo(_:)), for: .touchUpInside)
        return b
    }()
    
    private lazy var searchButton: UIButton = {
        let sb = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        sb.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: largeConfig), for: .normal)
        sb.tintColor = .systemPurple
        sb.addTarget(self, action: #selector(presentModally), for: .touchUpInside)
        return sb
    }()
    
    private lazy var dataTextField: UITextField = {
        let tf = UITextField(frame: .infinite)
        tf.placeholder = "Enter Text Here, then press the Search Icon"
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private lazy var playOrPauseButton: UIButton = {
        let b = UIButton()
        b.setTitle("Tap here to Play/Pause", for: .normal)
        b.backgroundColor = .systemGreen
        b.layer.cornerRadius = 10.0
        b.layer.shadowRadius = 10.0
        b.addTarget(self, action: #selector(playOrPausePressed(_:)), for: .touchUpInside)
        return b
    }()
    
    private lazy var breatheView: UIView = {
        let breath = UIHostingController(rootView: BreatheAnimation(viewModel: breathingViewModel))
        breath.view.backgroundColor = .systemTeal
        return breath.view
    }()
    
    //MARK: - Properties
    private var play: Bool = false
    
    //MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
//        overrideUserInterfaceStyle = .dark
        setUp()
        dataTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Methods
    @objc private func pushToHeartsDemo(_ sender: Any) {
        #if DEBUG
        print("Going to heart shape demo")
        #endif
        let profileView = UIHostingController(rootView: RepeatingAnimatedHeartShapeDemo())
        navigationController?.pushViewController(profileView, animated: true)
    }
    
    @objc private func presentModally(_ sender: Any) {
        let showDataVC = UIHostingController(rootView: ShowDataView(dataPassedIn: dataTextField.text ?? ""))
        present(showDataVC, animated: true, completion: nil)
    }
    
    @objc private func playOrPausePressed(_ sender: Any) {
        breathingViewModel.performAnimations()
    }
}

extension ViewController {
    private func setUp() {
        view.backgroundColor = .systemTeal
        navigationController?.isNavigationBarHidden = true

        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.width.equalToSuperview().inset(UIEdgeInsets(top: 20,left: 20,bottom: 20,right: 20))
            make.center.equalTo(view)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()  //if desired
        return true
    }
}

extension UIStackView {
    func addAllSubviews(_ controls: UIView...) {
        controls.forEach { addArrangedSubview($0) }
    }
}


