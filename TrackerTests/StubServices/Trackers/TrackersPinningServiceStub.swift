//
//  TrackersPinningServiceStub.swift
//  TrackerTests
//
//  Created by Pavel Razumov on 17.07.2023.
//

import Foundation
import Tracker

final class TrackersPinningServiceStub {}

// MARK: - TrackersPinningServiceProtocol
extension TrackersPinningServiceStub: TrackersPinningServiceProtocol {
	func pin(tracker: Tracker) {}
	func unpin(tracker: Tracker) {}
}
