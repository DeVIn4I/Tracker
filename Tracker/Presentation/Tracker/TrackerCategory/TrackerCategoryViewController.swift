//
//  TrackerCategoryViewController.swift
//  Tracker
//
//  Created by Pavel Razumov on 19.06.2023.
//

import UIKit

protocol TrackerCategoryViewControllerDelegate: AnyObject {
	func didRecieveCategory(_ category: TrackerCategory)
}

final class TrackerCategoryViewController: UIViewController {
	enum Flow {
		case normal
		case filter
	}

	private let flow: Flow

	private let helper: TrackerCategoryTableViewHelperProtocol
	private let router: TrackerCategoryRouterProtocol?
	private var viewModel: TrackerCategoryViewModelProtocol

	private let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .Medium.big
		label.textColor = .Dynamic.blackDay
		return label
	}()

	private lazy var placeholderView: TrackerPlaceholderView = {
		let view = TrackerPlaceholderView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.set(state: .emptyCategories)
		view.isHidden = self.viewModel.isPlaceholderHidden
		return view
	}()

	private lazy var categoriesTableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.register(
			TrackerCategoryTableViewCell.self,
			forCellReuseIdentifier: TrackerCategoryTableViewCell.reuseIdentifier
		)
		tableView.dataSource = self.helper
		tableView.delegate = self.helper
		tableView.rowHeight = 75
		tableView.separatorColor = .Static.gray
		return tableView
	}()

	private lazy var addNewCategoryButton: TrackerCustomButton = {
		let title = R.string.localizable.trackerCategoryAddCategoryButtonTitle()
		let button = TrackerCustomButton(state: .normal, title: title)
		button.translatesAutoresizingMaskIntoConstraints = false
		button.addTarget(self, action: #selector(self.didTapAddNewCategoryButton), for: .touchUpInside)
		return button
	}()

	private var selectedCategory: TrackerCategory?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		self.setupViewController()

		self.helper.delegate = self

		self.addSubviews()
		self.addConstraints()
		self.bind()
	}
	
	init(
		viewModel: TrackerCategoryViewModelProtocol,
		helper: TrackerCategoryTableViewHelperProtocol,
		router: TrackerCategoryRouterProtocol?,
		flow: Flow,
		selectedCategory: TrackerCategory?
	) {
		self.viewModel = viewModel
		self.helper = helper
		self.router = router
		self.flow = flow
		self.selectedCategory = selectedCategory

		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - TrackerCategoryTableViewHelperFullDelegate
extension TrackerCategoryViewController: TrackerCategoryTableViewHelperDelegate {
	var categories: [TrackerCategory] {
		self.viewModel.categories
	}

	var chosenCategory: TrackerCategory? {
		self.selectedCategory
	}
	
	func didSelect(category: TrackerCategory) {
		self.viewModel.didChoose(category: category)
	}
}

// MARK: - TrackerNewCategoryViewControllerDelegate
extension TrackerCategoryViewController: TrackerNewCategoryViewControllerDelegate {
	func dismissNewCategoryViewController() {
		self.dismiss(animated: true)
	}
}

private extension TrackerCategoryViewController {
	func addSubviews() {
		self.view.addSubview(titleLabel)
		self.view.addSubview(categoriesTableView)
		self.view.insertSubview(placeholderView, aboveSubview: categoriesTableView)

		if self.flow == .normal {
			self.view.addSubview(addNewCategoryButton)
		}
	}

	func addConstraints() {
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
			titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])

		NSLayoutConstraint.activate([
			categoriesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
			categoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			categoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			categoriesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -91)
		])

		NSLayoutConstraint.activate([
			placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
		])

		if self.flow == .normal {
			NSLayoutConstraint.activate([
				addNewCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
				addNewCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
				addNewCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
				addNewCategoryButton.heightAnchor.constraint(equalToConstant: 60)
			])
		}
	}

	func bind() {
		self.viewModel.onCategoriesChanged = { [weak self] in
			self?.categoriesTableView.reloadData()
		}

		self.viewModel.onIsPlaceholderHiddenChanged = { [weak self] in
			guard let self = self else { return }
			self.placeholderView(shouldHide: self.viewModel.isPlaceholderHidden)
		}
	}
}

// MARK: - Actions
private extension TrackerCategoryViewController {
	@objc
	func didTapAddNewCategoryButton() {
		self.router?.navigateToNewCategoryScreen(from: self)
	}
}

private extension TrackerCategoryViewController {
	func placeholderView(shouldHide: Bool) {
		self.placeholderView.isHidden = shouldHide
	}
}

private extension TrackerCategoryViewController {
	func setupViewController() {
		self.view.backgroundColor = .Dynamic.whiteDay

		switch self.flow {
		case .filter:
			self.setupForFilterFlow()
		case .normal:
			self.setupForNormalFlow()
		}
	}

	func setupForFilterFlow() {
		let title = R.string.localizable.trackerCategoryFlowFilterViewControllerTitle()
		self.titleLabel.text = title
		self.titleLabel.sizeToFit()
	}

	func setupForNormalFlow() {
		let title = R.string.localizable.trackerCategoryFlowNormalViewControllerTitle()
		self.titleLabel.text = title
		self.titleLabel.sizeToFit()
	}
}
