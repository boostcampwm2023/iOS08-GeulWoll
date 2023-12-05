//
//  SignUpContainerViewController.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/5/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import DesignSystem
import UIKit

// MARK: - SignUpContainerViewController

public final class SignUpContainerViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []

  private let signUpGenderBirthViewController: SignUpGenderBirthViewController
  private let signUpProfileViewController: SignUpProfileViewController

  private lazy var signUpGenderBirthView = signUpGenderBirthViewController.view
  private lazy var signUpProfileView = signUpProfileViewController.view

  private let gwPageControl: GWPageControl = {
    let gwPageControl = GWPageControl(count: 2)
    gwPageControl.translatesAutoresizingMaskIntoConstraints = false
    return gwPageControl
  }()

  public init(
    signUpGenderBirthViewController: SignUpGenderBirthViewController,
    signUpProfileViewController: SignUpProfileViewController
  ) {
    self.signUpGenderBirthViewController = signUpGenderBirthViewController
    self.signUpProfileViewController = signUpProfileViewController
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    configureUI()
    bindUI()
  }
}

private extension SignUpContainerViewController {
  func bindUI() {
    signUpGenderBirthViewController.nextButtonTapPublisher
      .sink { [weak self] _ in
        self?.signUpGenderBirthView?.isHidden = true
        self?.signUpProfileView?.isHidden = false
        self?.gwPageControl.next()
      }
      .store(in: &subscriptions)
  }
}

private extension SignUpContainerViewController {
  func configureUI() {
    view.backgroundColor = DesignSystemColor.secondaryBackground
    navigationController?.navigationBar.isHidden = true
    let safeArea = view.safeAreaLayoutGuide

    view.addSubview(gwPageControl)
    NSLayoutConstraint.activate([
      gwPageControl.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Metrics.safeAreaInterval),
      gwPageControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Metrics.safeAreaInterval),
    ])

    guard let signUpGenderBirthView,
          let signUpProfileView
    else {
      return
    }

    signUpGenderBirthView.translatesAutoresizingMaskIntoConstraints = false
    add(child: signUpGenderBirthViewController)
    NSLayoutConstraint.activate([
      signUpGenderBirthView.topAnchor.constraint(equalTo: gwPageControl.bottomAnchor),
      signUpGenderBirthView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      signUpGenderBirthView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      signUpGenderBirthView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
    ])

    signUpProfileView.translatesAutoresizingMaskIntoConstraints = false
    add(child: signUpProfileViewController)
    NSLayoutConstraint.activate([
      signUpProfileView.topAnchor.constraint(equalTo: gwPageControl.bottomAnchor),
      signUpProfileView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      signUpProfileView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      signUpProfileView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
    ])

    signUpProfileView.isHidden = true
  }

  func add(child viewController: UIViewController) {
    addChild(viewController)
    view.addSubview(viewController.view)
    viewController.didMove(toParent: viewController)
  }
}

// MARK: - Metrics

private enum Metrics {
  static let pageControlInterval: CGFloat = 30
  static let safeAreaInterval: CGFloat = 24
  static let bottomInterval: CGFloat = 215
  static let calendarHeight: CGFloat = 51
}
