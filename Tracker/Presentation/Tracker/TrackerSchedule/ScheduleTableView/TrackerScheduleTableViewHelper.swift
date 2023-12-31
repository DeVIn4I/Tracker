//
//  TrackerScheduleTableViewHelper.swift
//  Tracker
//
//  Created by Pavel Razumov on 18.04.2023.
//

import UIKit

protocol TrackerScheduleTableViewHelperProtocol: UITableViewDelegate, UITableViewDataSource {
    var presenter: TrackerSchedulePresenterProtocol? { get set }
}

protocol TrackerScheduleTableViewHelperDelegateProtocol: AnyObject {
    func didChangeSwitchValue(_ cell: TrackerScheduleTableViewCell, isOn: Bool)
}

final class TrackerScheduleTableViewHelper: NSObject, TrackerScheduleTableViewHelperProtocol {
    weak var presenter: TrackerSchedulePresenterProtocol?
    
    // MARK: - UITableViewDelegate
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        75
    }
    
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        presenter?.weekDays.count ?? 0
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
			withIdentifier: TrackerScheduleTableViewCell.reuseIdentifier,
			for: indexPath) as? TrackerScheduleTableViewCell
        else { return UITableViewCell() }

		guard let presenter = presenter else { return UITableViewCell() }
        
        let weekDay = presenter.weekDays[indexPath.row]
        cell.weekDay = weekDay
        cell.cellTitle = weekDay.fullStringRepresentaion
        cell.delegate = self
        
        if presenter.selectedWeekDays.contains(weekDay) {
            cell.isDaySwitchOn = true
        }

		let configuredCell = cell.configure(
			cellIndexPath: indexPath,
			lastCellIndexPath: tableView.lastCellIndexPath,
			entityCount: presenter.weekDays.count,
			tableViewWidth: tableView.bounds.width
		)
        
        return configuredCell
    }
}

extension TrackerScheduleTableViewHelper: TrackerScheduleTableViewHelperDelegateProtocol {
    func didChangeSwitchValue(_ cell: TrackerScheduleTableViewCell, isOn: Bool) {
        guard let weekDay = cell.weekDay else { return }
        presenter?.didChangeSwitchValue(weekDay: weekDay, isOn: isOn)
    }
}
