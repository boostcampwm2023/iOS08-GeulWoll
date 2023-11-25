//
//  WorkoutSessionContainerViewModel.swift
//  RecordFeature
//
//  Created by 홍승현 on 11/23/23.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Combine
import CoreLocation
import Foundation

// MARK: - WorkoutSessionContainerViewModelInput

public struct WorkoutSessionContainerViewModelInput {
  let endWorkoutPublisher: AnyPublisher<Void, Never>
  let locationPublisher: AnyPublisher<[CLLocation], Never>
  let healthPublisher: AnyPublisher<WorkoutHealth, Never>
}

public typealias WorkoutSessionContainerViewModelOutput = AnyPublisher<WorkoutSessionContainerState, Never>

// MARK: - WorkoutSessionContainerState

public enum WorkoutSessionContainerState {
  case idle
}

// MARK: - WorkoutSessionContainerViewModelRepresentable

protocol WorkoutSessionContainerViewModelRepresentable {
  func transform(input: WorkoutSessionContainerViewModelInput) -> WorkoutSessionContainerViewModelOutput
}

// MARK: - WorkoutSessionContainerViewModel

final class WorkoutSessionContainerViewModel {
  // MARK: - Properties

  private var subscriptions: Set<AnyCancellable> = []
}

// MARK: WorkoutSessionContainerViewModelRepresentable

extension WorkoutSessionContainerViewModel: WorkoutSessionContainerViewModelRepresentable {
  public func transform(input: WorkoutSessionContainerViewModelInput) -> WorkoutSessionContainerViewModelOutput {
    subscriptions.removeAll()

    input.locationPublisher
      .combineLatest(input.healthPublisher, input.endWorkoutPublisher) { location, health, _ in
        return (location, health)
      }
      .sink { _ in
      }
      .store(in: &subscriptions)

    let initialState: WorkoutSessionContainerViewModelOutput = Just(.idle).eraseToAnyPublisher()

    return initialState
  }
}
