//
//  TrackerCoreData.swift
//  Tracker
//
//  Created by Pavel Razumov on 01.05.2023.
//
//

import Foundation
import CoreData

@objc(TrackerCoreData)
final class TrackerCoreData: NSManagedObject {
	static let entityName = String(describing: TrackerCoreData.self)

	@nonobjc class func fetchRequest() -> NSFetchRequest<TrackerCoreData> {
		NSFetchRequest<TrackerCoreData>(entityName: TrackerCoreData.entityName)
	}

    @NSManaged var colorHex: String
    @NSManaged var emoji: String
    @NSManaged var id: String
	@NSManaged var previousCategoryId: String
    @NSManaged var title: String
    @NSManaged var type: Int16
    @NSManaged var weekDays: String
	@NSManaged var isPinned: Bool
    @NSManaged var category: TrackerCategoryCoreData
    @NSManaged var records: NSSet
}

// MARK: Generated accessors for records
extension TrackerCoreData {
    @objc(addRecordsObject:)
    @NSManaged func addToRecords(_ value: TrackerRecordCoreData)

    @objc(removeRecordsObject:)
    @NSManaged func removeFromRecords(_ value: TrackerRecordCoreData)

    @objc(addRecords:)
    @NSManaged func addToRecords(_ values: NSSet)

    @objc(removeRecords:)
    @NSManaged func removeFromRecords(_ values: NSSet)
}
