//
//  Record.swift
//  RecordFeature
//
//  Created by 안종표 on 2023/11/21.
//  Copyright © 2023 kr.codesquad.boostcamp8. All rights reserved.
//

import Foundation

// MARK: - Record

/// 기록 목록을 표시하기위해 사용하는 모델입니다.
struct Record {
  /// 현재 운동의 목록을 나타냅니다.
  let mode: String

  /// 몇시몇분부터 몇시몇분까지 운동하였는지 나타내줍니다.
  let timeToTime: String

  /// 총 운동한 거리를 "미터"단위로 표시해줍니다.
  let distance: Int
}

// MARK: Codable

extension Record: Codable {}
