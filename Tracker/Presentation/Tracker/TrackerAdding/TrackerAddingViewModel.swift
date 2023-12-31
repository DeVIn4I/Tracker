//
//  TrackerAddingViewModel.swift
//  Tracker
//
//  Created by Pavel Razumov on 16.07.2023.
//

import UIKit

typealias Binding = (() -> Void)

final class TrackerAddingViewModel {
	var onIsConfirmButtonDisabledChanged: Binding?
	var onIsErrorHiddenChanged: Binding?
	var onOptionsTitlesChanged: Binding?
	var onTrackerTitleChanged: Binding?
	var onSelectedWeekDaysChanged: Binding?
	var onSelectedCategoryChanged: Binding?
	var onSelectedEmojiChanged: Binding?
	var onSelectedColorChanged: Binding?

	let optionsTitles: [String]
	let viewControllerTitle: String

	var trackerTitle: String? = nil {
		didSet {
			self.onTrackerTitleChanged?()
			self.checkToEnableConfirmTrackerButton()
		}
	}

	var selectedWeekDays: Set<WeekDay> = [] {
		didSet {
			self.onSelectedWeekDaysChanged?()
			self.checkToEnableConfirmTrackerButton()
		}
	}

	var selectedCategory: TrackerCategory? = nil {
		didSet {
			self.onSelectedCategoryChanged?()
			self.checkToEnableConfirmTrackerButton()
		}
	}

	var selectedEmoji: String? = nil {
		didSet {
			self.onSelectedEmojiChanged?()
			self.checkToEnableConfirmTrackerButton()
		}
	}

	var selectedColor: UIColor? = nil {
		didSet {
			self.onSelectedColorChanged?()
			self.checkToEnableConfirmTrackerButton()
		}
	}

	var isConfirmButtonDisabled: Bool = true {
		didSet {
			self.onIsConfirmButtonDisabledChanged?()
		}
	}

	var isErrorHidden: Bool = true {
		didSet {
			self.onIsErrorHiddenChanged?()
			self.checkToEnableConfirmTrackerButton()
		}
	}

	private let trackersAddingService: TrackersAddingServiceProtocol
	private let trackerType: Tracker.TrackerType

	init(
		trackersAddingService: TrackersAddingServiceProtocol,
		trackerType: Tracker.TrackerType,
		optionTitles: [String],
		viewControllerTitle: String
	) {
		self.trackersAddingService = trackersAddingService
		self.trackerType = trackerType
		self.optionsTitles = optionTitles
		self.viewControllerTitle = viewControllerTitle

		if self.trackerType == .irregularEvent {
			self.selectedWeekDays = Set(WeekDay.allCases)
		}
	}
}

// MARK: - TrackerAddingViewModelProtocol
extension TrackerAddingViewModel: TrackerAddingViewModelProtocol {
	func didChangeTracker(title: String) {
		self.isErrorHidden = title.count < 38
	}

	func didConfirmTracker() {
		guard let title = self.trackerTitle,
			  let color = self.selectedColor,
			  let emoji = self.selectedEmoji,
			  let category = self.selectedCategory
		else { return }

		let schedule = self.trackerType == .irregularEvent ? Set(WeekDay.allCases) : self.selectedWeekDays

		self.trackersAddingService.addTracker(
			title: title,
			schedule: schedule,
			type: self.trackerType,
			color: color,
			emoji: emoji,
			categoryId: category.id
		)
	}

	func didSelect(color: UIColor) {
		self.selectedColor = color
	}

	func didSelect(emoji: String) {
		self.selectedEmoji = emoji
	}

	func didSelect(category: TrackerCategory) {
		self.selectedCategory = category
	}

	func didSelect(weekDays: Set<WeekDay>) {
		self.selectedWeekDays = weekDays
	}

	func didSelect(title: String) {
		self.trackerTitle = title
	}
}

// MARK: - TrackerScheduleViewControllerDelegate
extension TrackerAddingViewModel: TrackerScheduleViewControllerDelegate {
	func didRecieveSelectedWeekDays(_ weekDays: Set<WeekDay>) {
		self.selectedWeekDays = weekDays
	}
}

// MARK: - TrackerCategoryViewControllerDelegate
extension TrackerAddingViewModel: TrackerCategoryViewControllerDelegate {
	func didRecieveCategory(_ category: TrackerCategory) {
		self.selectedCategory = category
	}
}

private extension TrackerAddingViewModel {
	func checkToEnableConfirmTrackerButton() {
        guard let trackerTitle = self.trackerTitle,
			  let _ = self.selectedColor,
			  let _ = self.selectedEmoji,
			  let _ = self.selectedCategory
        else { return }

		let enablingCondition = !trackerTitle.isEmpty && self.isErrorHidden && !self.selectedWeekDays.isEmpty
		self.isConfirmButtonDisabled = enablingCondition == false
	}
}
