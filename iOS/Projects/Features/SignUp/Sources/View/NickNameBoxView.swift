//
//  NickNameBoxView.swift
//  SignUpFeature
//
//  Created by 안종표 on 12/4/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CombineCocoa
import DesignSystem
import UIKit

// MARK: - NickNameBoxView

final class NickNameBoxView: UIView {
  private var subscriptions: Set<AnyCancellable> = []

  private let nickNameDidChangedSubject = PassthroughSubject<String, Never>()

  var nickNameDidChangedPublisher: AnyPublisher<String, Never> {
    return nickNameDidChangedSubject.eraseToAnyPublisher()
  }

  private let textField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.font = .systemFont(ofSize: 16, weight: .semibold)
    textField.textColor = .black
    textField.placeholder = "닉네임을 입력해주세요!"
    return textField
  }()

  private let cancelButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setImage(UIImage(systemName: "xmark"), for: .normal)
    button.tintColor = DesignSystemColor.main03
    return button
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    bindUI()
    disabledNickName()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("NO Xib")
  }
}

private extension NickNameBoxView {
  func configureUI() {
    backgroundColor = .systemBackground
    layer.borderColor = DesignSystemColor.main03.cgColor
    layer.borderWidth = 1.5
    layer.cornerRadius = 10.0

    addSubview(textField)
    NSLayoutConstraint.activate([
      textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      textField.topAnchor.constraint(equalTo: topAnchor, constant: 13),
      textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13),
    ])

    addSubview(cancelButton)
    NSLayoutConstraint.activate([
      cancelButton.topAnchor.constraint(equalTo: topAnchor, constant: 13),
      cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      cancelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13),
      cancelButton.widthAnchor.constraint(equalToConstant: 32),
    ])
  }

  func enabledNickName() {
    textField.textColor = .black
    textField.layer.borderColor = DesignSystemColor.main03.cgColor
    cancelButton.tintColor = DesignSystemColor.main03
  }

  func disabledNickName() {
    textField.textColor = DesignSystemColor.error
    textField.layer.borderColor = DesignSystemColor.error.cgColor
    cancelButton.tintColor = DesignSystemColor.error
  }

  func bindUI() {
    cancelButton.publisher(.touchUpInside)
      .sink { [weak self] _ in
        self?.textField.text = ""
      }
      .store(in: &subscriptions)

    textField.publisher(.valueChanged)
      .sink { [weak self] _ in
        guard let text = self?.textField.text else {
          return
        }
        self?.nickNameDidChangedSubject.send(text)
      }
      .store(in: &subscriptions)
  }
}
