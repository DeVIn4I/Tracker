//
//  TrackersRecordFetcher.swift
//  Tracker
//
//  Created by Pavel Razumov on 07.07.2023.
//

import Foundation
import CoreData

protocol TrackersRecordDataFetcherProtocol {
	func fetchCompletedRecords(date: Date) -> [TrackerRecordCoreData]
	func completedTimesCount(trackerId: String) -> Int
}

struct TrackersRecordDataFetcher {
	private let trackersRecordDataStore: TrackersRecordDataStore

	init(trackersRecordDataStore: TrackersRecordDataStore) {
		self.trackersRecordDataStore = trackersRecordDataStore
	}
}

extension TrackersRecordDataFetcher: TrackersRecordDataFetcherProtocol {
	func fetchCompletedRecords(date: Date) -> [TrackerRecordCoreData] {
		guard let date = date.withoutTime else { return [] }
		let records = self.trackersRecordDataStore.completedTrackers(for: date)
		return records
	}

	func completedTimesCount(trackerId: String) -> Int {
		let count = self.trackersRecordDataStore.completedTimesCount(trackerId: trackerId)
		return count ?? 0
	}
}
