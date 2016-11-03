//
//  ProductViewController.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {

    // MARK: Properties
    var tableView: UITableView!
    var basketButton: UIButton!
    var spinner = CustomSpinner()

    lazy var fetchRequestsController: NSFetchedResultsController = {
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        let fetchRequest = NSFetchRequest(entityName: EntityName.Product)
        fetchRequest.sortDescriptors = [idSort]
        let fetchRequestsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: objContext(), sectionNameKeyPath: nil, cacheName: nil)
        fetchRequestsController.delegate = self
        return fetchRequestsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        configureNavigationBar()
        configureRightBarButtonItem()
        configureTableView()
        configureFetchData()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.ProductInsertCurrencyExchangeCompleted, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.Product), name: Notification.ProductInsertCurrencyExchangeCompleted, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.ProductInsertCurrencyExchangeFailed, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.Product), name: Notification.ProductInsertCurrencyExchangeFailed, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.ProductCurrencyExchangeNoChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.Product), name: Notification.ProductCurrencyExchangeNoChange, object: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK:- UI Configuration
extension ProductViewController {
    func configureNavigationBar() {
        title = Translation.Groceries
        navigationItem.hidesBackButton = true
    }
    func configureRightBarButtonItem() {
        navigationItem.rightBarButtonItem = basketBarButtonItem(target: self)
    }
    func configureFetchData() {
        do {
            try fetchRequestsController.performFetch()
        } catch {
            displayAlertWithTitle(Translation.Sorry, message: Translation.FetchDataErrorMessage, viewController: self)
        }
    }
    func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.exclusiveTouch = true
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.TableView)
        view.addSubview(tableView)
        
        tableView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(tableView.trailingAnchor).active = true
        bottomLayoutGuide.topAnchor.constraintEqualToAnchor(tableView.bottomAnchor).active = true
    }
}
// MARK:- Internal Action
extension ProductViewController {
    func receivedNotificationProduct(notification: NSNotification) {
        if (notification.name == Notification.ProductInsertCurrencyExchangeCompleted) || (notification.name == Notification.ProductCurrencyExchangeNoChange) {
            removeSpinner()
            let pushVC = UIStoryboard.basketViewController() as BasketViewController!
            navigationController?.pushViewController(pushVC, animated: true)
        }
        else if notification.name == Notification.ProductInsertCurrencyExchangeFailed {
            removeSpinner()
            displayAlertWithTitle(Translation.ApiErrorTitle, message: Translation.ApiErrorMessage, viewController: self)
        }
    }
    func addSpinner() {
        if let pvc = parentViewController?.view {
            spinner.runSpinnerWithIndicator(pvc)
            spinner.start()
        }
    }
    func removeSpinner() {
        spinner.stop()
    }
    func gotoBasket(sender: UIBarButtonItem) {
        if isNetworkOrCellularCoverageReachable() {
            addSpinner()
            let groceries = Groceries()
            groceries.delegate = self
            groceries.getCurrencyExchangeFromAPI(source: ConstantKeys.Product)
        }
        else {
            displayAlertWithTitle(Translation.NetworkErrorTitle, message: Translation.NetworkErrorMessage, viewController: self)
        }
    }
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let item = fetchRequestsController.objectAtIndexPath(indexPath) as! Product
        if let name = item.name, let priceInfo = item.priceInfo, price = item.price {
            cell.textLabel?.text = String(format: "%@ (%@)", name, priceInfo)
            cell.detailTextLabel?.text = String(format: "%@ %@", ConstantKeys.GBP, currencyValueStyle(Double(price)))
        }
        else {
            cell.textLabel?.text = Translation.DataNotAvailable
            cell.detailTextLabel?.text = Translation.DataNotAvailable
        }
        cell.textLabel?.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.SuperSmall)
        cell.textLabel?.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        cell.detailTextLabel?.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.SuperSmall)
        cell.detailTextLabel?.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        cell.exclusiveTouch = true
    }
}
// MARK:- UITableViewDataSource
extension ProductViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = fetchRequestsController.sections {
            return sections.count
        }
        return 0
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchRequestsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.TableView, forIndexPath: indexPath) 
        configureCell(cell, indexPath: indexPath)
        return cell
    }
}
// MARK:- UITableViewDelegate
extension ProductViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let itemData = fetchRequestsController.objectAtIndexPath(indexPath) as! Product
        let pushVC = UIStoryboard.productDetailViewController() as ProductDetailViewController!
        pushVC.itemData = itemData
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
}
// MARK:- NSFetchedResultsControllerDelegate
extension ProductViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        case .Update:
            if let indexPath = indexPath {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                    configureCell(cell, indexPath: indexPath)
                }
            }
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
// MARK: GroceriesDelegate
extension ProductViewController: GroceriesDelegate {
    func ApiError() {
        removeSpinner()
        displayAlertWithTitle(Translation.ApiErrorTitle, message: Translation.ApiErrorMessage, viewController: self)
    }
}