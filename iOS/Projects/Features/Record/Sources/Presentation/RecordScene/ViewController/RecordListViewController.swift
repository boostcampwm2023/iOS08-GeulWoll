//
//  RecordListViewController.swift
//  ProjectDescriptionHelpers
//
//  Created by 안종표 on 2023/11/16.
//

import Combine
import DesignSystem
import UIKit

// MARK: - RecordListViewController

final class RecordListViewController: UIViewController {
  private var subscriptions: Set<AnyCancellable> = []
  private let appear = PassthroughSubject<Void, Never>()
  private let moveSelectScene = PassthroughSubject<Void, Never>()

  private let viewModel: RecordListViewModel
  private var workoutInformationDataSource: WorkoutInformationDataSource?

  private let todayLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "오늘\n ??월 ??일 ?요일"
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .title1, with: .traitBold)
    return label
  }()

  private lazy var workoutInformationCollectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumLineSpacing = 6
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.delegate = self
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()

  private let recordButton: UIButton = {
    var configuration = UIButton.Configuration.mainEnabled(title: "기록하러가기")
    configuration.font = .preferredFont(forTextStyle: .headline, with: .traitBold)
    let button = UIButton(configuration: configuration)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  init(viewModel: RecordListViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("No Xib")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    configureUI()
    configureDataSource()
    bind()
    appear.send()
  }
}

// MARK: Binding

private extension RecordListViewController {
  func bind() {
    subscriptions.forEach {
      $0.cancel()
    }
    subscriptions.removeAll()
    let input = RecordListViewModelInput(
      appear: appear.eraseToAnyPublisher(),
      moveSelectScene: moveSelectScene.eraseToAnyPublisher()
    )
    let output = viewModel.transform(input: input)
    output.sink { [weak self] state in
      self?.render(output: state)
    }
    .store(in: &subscriptions)
  }

  func render(output: RecordListState) {
    switch output {
    case .idle:
      // TODO: 뷰 교체
      let temp = ""
    case let .success(records):
      let workoutInformationItems = records.map {
        WorkoutInformationItem(sport: $0.mode.decription, time: $0.timeToTime, distance: "\($0.distance)km")
      }
      configureSnapShot(items: workoutInformationItems)
    }
  }
}

// MARK: UI

private extension RecordListViewController {
  func configureUI() {
    view.addSubview(todayLabel)
    NSLayoutConstraint.activate([
      todayLabel.topAnchor.constraint(equalTo: view.topAnchor),
      todayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      todayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    view.addSubview(workoutInformationCollectionView)
    NSLayoutConstraint.activate([
      workoutInformationCollectionView.topAnchor.constraint(equalTo: todayLabel.bottomAnchor, constant: Metrics.componentInterval),
      workoutInformationCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      workoutInformationCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    view.addSubview(recordButton)
    NSLayoutConstraint.activate([
      recordButton.topAnchor.constraint(equalTo: workoutInformationCollectionView.bottomAnchor, constant: Metrics.componentInterval),
      recordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      recordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      recordButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  func configureDataSource() {
    let cellRegistration = WorkoutInformationCellRegistration { cell, _, item in
      cell.configure(workoutInformation:
        WorkoutInformation(
          sport: item.sport,
          time: item.time,
          distance: item.distance
        )
      )
    }

    workoutInformationDataSource = WorkoutInformationDataSource(
      collectionView: workoutInformationCollectionView,
      cellProvider: { collectionView, indexPath, itemIdentifier in

        collectionView.dequeueConfiguredReusableCell(
          using: cellRegistration,
          for: indexPath,
          item: itemIdentifier
        )
      }
    )
  }

  func configureSnapShot(items: [WorkoutInformationItem]) {
    var snapShot = WorkoutInformationSnapShot()
    snapShot.appendSections([.workoutList])
    snapShot.appendItems(items)
    workoutInformationDataSource?.apply(snapShot)
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension RecordListViewController: UICollectionViewDelegateFlowLayout {
  public func collectionView(
    _: UICollectionView,
    layout _: UICollectionViewLayout,
    sizeForItemAt _: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width / Metrics.itemWidthRatio, height: workoutInformationCollectionView.frame.height / Metrics.itemHeightRatio)
  }
}

// MARK: - Metrics

private enum Metrics {
  static let componentInterval: CGFloat = 24
  static let itemWidthRatio: CGFloat = 2.45
  static let itemHeightRatio: CGFloat = 1.5
}

// MARK: RecordViewController DiffableDataSource

private extension RecordListViewController {
  typealias WorkoutInformationCellRegistration = UICollectionView.CellRegistration<WorkoutInformationCollectionViewCell, WorkoutInformationItem>
  typealias WorkoutInformationDataSource = UICollectionViewDiffableDataSource<Section, WorkoutInformationItem>
  typealias WorkoutInformationSnapShot = NSDiffableDataSourceSnapshot<Section, WorkoutInformationItem>
}

// MARK: - Section

private enum Section {
  case workoutList
}

// MARK: - WorkoutInformationItem

private struct WorkoutInformationItem: Identifiable, Hashable {
  let id = UUID()
  let sport: String
  let time: String
  let distance: String
}
