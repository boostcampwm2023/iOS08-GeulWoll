//
//  WorkoutEnvironmentSetupUseCase.swift
//  RecordFeature
//
//  Created by MaraMincho on 11/21/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation


protocol WorkoutEnvironmentSetupNetworkRepositoryRepresentable {
  func getData()
}
// MARK: - WorkoutEnvironmentSetupUseCaseRepresentable

protocol WorkoutEnvironmentSetupUseCaseRepresentable {}

// MARK: - WorkoutEnvironmentSetupUseCase

final class WorkoutEnvironmentSetupUseCase: WorkoutEnvironmentSetupUseCaseRepresentable {}
