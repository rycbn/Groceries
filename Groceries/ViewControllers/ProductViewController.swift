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
    var tableData = [Product]()

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
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        let fetchRequest = NSFetchRequest(entityName: EntityName.Product)
        fetchRequest.sortDescriptors = [idSort]
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest, completionBlock: { (result: NSAsynchronousFetchResult!) -> Void in
            self.tableData = result.finalResult as! [Product]
            self.tableView.reloadData()
        })
        do {
            try appDelegate().coreDataStack.context.executeRequest(asyncFetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func configureTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = true
        tableView.clearsContextBeforeDrawing = true
        tableView.clipsToBounds = true
        tableView.autoresizesSubviews = true
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.multipleTouchEnabled = false
        tableView.allowsMultipleSelection = false
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
        spinner.runSpinnerWithIndicator(parentViewController!.view)
        spinner.start()
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
}
// MARK:- UITableViewDataSource, UITableViewDelegate
extension ProductViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Height.Cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: CellIdentifier.TableView)
        let item = tableData[indexPath.row]
        cell.textLabel?.text = String(format: "%@ (%@)", item.name!, item.priceInfo!)
        cell.textLabel?.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.SuperSmall)
        cell.textLabel?.textColor = UIColor.colorFromHexRGB(Color.SlateGray)

        cell.detailTextLabel?.text = String(format: "%@ %@", ConstantKeys.GBP, currencyValueStyle(Double(item.price!)))
        cell.detailTextLabel?.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.SuperSmall)
        cell.detailTextLabel?.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        
        cell.exclusiveTouch = true
        cell.selectionStyle = .None
        cell.setNeedsDisplay()
        cell.setNeedsLayout()
        cell.setNeedsUpdateConstraints()
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let itemData = tableData[indexPath.row]
        let pushVC = UIStoryboard.productDetailViewController() as ProductDetailViewController!
        pushVC.itemData = itemData
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
}
// MARK: GroceriesDelegate
extension ProductViewController: GroceriesDelegate {
    func ApiError() {
        removeSpinner()
        displayAlertWithTitle(Translation.ApiErrorTitle, message: Translation.ApiErrorMessage, viewController: self)
    }
}