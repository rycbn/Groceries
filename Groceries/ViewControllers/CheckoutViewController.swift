//
//  CheckoutViewController.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreData

class CheckoutViewController: UIViewController {

    // MARK: Properties
    var addQtyAlertAction: UIAlertAction!
    var pickerView: UIPickerView!
    var doneButton: UIButton!
    var backgroundView: UIView!
    
    var currency: CurrencyExchange!
    var currencyCodeSelected: String!
    var currencyRateSelected: Double!
    
    var tableView = UITableView()
    var divLabel = UILabel()
    var headerLabel = UILabel()
    var confirmButton = UIButton(type: .Custom)
    var tableData = [CartItem]()
    var spinner = CustomSpinner()
    var pickerData = [CurrencyExchange]()
    var currencySelectedIndex = NSInteger()
    var isExchangeMode = Bool()
    var currencyCode = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        configureFetchData()
        configureNavigationBar()
        configureLeftBarButtonItem()
        configureRightBarButtonItem()
        configureHeaderLabel()
        configureContinueCheckoutButton()
        configureDivLabel()
        configureTableView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.Reload, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.Checkout), name: Notification.Reload, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension CheckoutViewController {
    func configureFetchData() {
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        let fetchRequestCart = NSFetchRequest(entityName: EntityName.CartItem)
        fetchRequestCart.sortDescriptors = [idSort]
        let asyncFetchRequestCart = NSAsynchronousFetchRequest(fetchRequest: fetchRequestCart, completionBlock: { (result: NSAsynchronousFetchResult!) -> Void in
            self.tableData = result.finalResult as! [CartItem]
            self.tableView.reloadData()
        })
        do {
            try appDelegate().coreDataStack.context.executeRequest(asyncFetchRequestCart)
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        let stringSort = NSSortDescriptor(key: "code", ascending: true)
        let fetchRequestExchange = NSFetchRequest(entityName: EntityName.CurrencyExchange)
        currencyCode = isExchangeMode ? getDefaultCurrencyExchange().code! : ConstantKeys.GBP
        fetchRequestExchange.sortDescriptors = [stringSort]
        let asyncFetchRequestExchange = NSAsynchronousFetchRequest(fetchRequest: fetchRequestExchange, completionBlock: { (result: NSAsynchronousFetchResult!) -> Void in
            self.pickerData = result.finalResult as! [CurrencyExchange]
            self.currency = self.pickerData.first!
            for (index, curr) in self.pickerData.enumerate() {
                if curr.code == self.currencyCode {
                    self.currencySelectedIndex = index
                    break
                }
            }
        })
        do {
            try appDelegate().coreDataStack.context.executeRequest(asyncFetchRequestExchange)
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    func configureNavigationBar() {
        title = Translation.Groceries
    }
    func configureLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = backBarButtonItem(target: self)
    }
    func configureRightBarButtonItem() {
        navigationItem.rightBarButtonItem = exchangeBarButtonItem(target: self)
    }
    func configureHeaderLabel() {

        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        func getItemString() -> String {
            return CartItem.getTotal().0 == 1 ? Translation.Item.lowercaseString : Translation.Items.lowercaseString
        }

        let totalItem = CartItem.getTotal().cart
        var totalAmount = Double()
        var totalAmountInString = String()
        var headerString = String()
        
        if isExchangeMode {
            totalAmount = CurrencyExchange.conversion(CartItem.getTotal().amount, rate: getDefaultCurrencyExchange().rate!)
            totalAmountInString = currencyValueStyle(totalAmount)
            currencyCode = getDefaultCurrencyExchange().code!
            headerString = String(format: "%@ (%li %@): %@ %@", Translation.BasketSubtotal, totalItem, getItemString(), currencyCode, totalAmountInString)
        }
        else {
            totalAmount = CartItem.getTotal().amount
            totalAmountInString = currencyValueStyle(totalAmount)
            currencyCode = ConstantKeys.GBP
            headerString = String(format: "%@ (%li %@): %@ %@", Translation.BasketSubtotal, totalItem, getItemString(), currencyCode, totalAmountInString)
        }
        
        headerLabel.text = headerString
        headerLabel.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.SuperSmall)
        headerLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        headerLabel.textAlignment = .Left
        headerLabel.numberOfLines = 1
        headerLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(headerLabel)
        
        headerLabel.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        headerLabel.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor, constant: Padding.Left.Regular).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(headerLabel.trailingAnchor, constant: Padding.Right.Regular).active = true
        headerLabel.heightAnchor.constraintEqualToConstant(35).active = true
    }
    func configureContinueCheckoutButton() {
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.exclusiveTouch = true
        confirmButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Normal)
        confirmButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Highlighted)
        confirmButton.backgroundColor = UIColor.colorFromHexRGB(Color.Blue)
        confirmButton.titleLabel?.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.Small)
        confirmButton.layer.borderWidth = 1.0
        confirmButton.layer.borderColor = UIColor.colorFromHexRGB(Color.Blue).CGColor
        confirmButton.layer.cornerRadius = 5.0
        confirmButton.isAccessibilityElement = true
        confirmButton.setTitle(Translation.ConfirmOrder, forState: .Normal)
        confirmButton.setTitle(Translation.ConfirmOrder, forState: .Highlighted)
        confirmButton.addTarget(self, action: Selector(Selectors.ConfirmOrder), forControlEvents: .TouchUpInside)
        view.addSubview(confirmButton)
        
        confirmButton.topAnchor.constraintEqualToAnchor(headerLabel.bottomAnchor).active = true
        confirmButton.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor, constant: Padding.Left.Regular).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(confirmButton.trailingAnchor, constant: Padding.Right.Regular).active = true
        confirmButton.heightAnchor.constraintEqualToConstant(Height.Button).active = true
    }
    func configureDivLabel() {
        divLabel.translatesAutoresizingMaskIntoConstraints = false
        divLabel.backgroundColor = UIColor.colorFromHexRGB(Color.LightGray)
        view.addSubview(divLabel)
        
        divLabel.topAnchor.constraintEqualToAnchor(confirmButton.bottomAnchor, constant: (Padding.Top.RegularHalf)).active = true
        divLabel.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(divLabel.trailingAnchor).active = true
        divLabel.heightAnchor.constraintEqualToConstant(1).active = true
    }
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.exclusiveTouch = true
        tableView.rowHeight = Height.BasketCell
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.TableView)
        view.addSubview(tableView)
        
        tableView.topAnchor.constraintEqualToAnchor(divLabel.bottomAnchor, constant: (Padding.Top.RegularHalf)).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(tableView.trailingAnchor).active = true
        bottomLayoutGuide.topAnchor.constraintEqualToAnchor(tableView.bottomAnchor).active = true
    }
    func configurePickerView() {
        pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true
        pickerView.selectRow(currencySelectedIndex, inComponent: 0, animated: true)
        pickerView.backgroundColor = UIColor.colorFromHexRGB(Color.Gray)
        pickerView.layer.borderColor = UIColor.colorFromHexRGB(Color.Gray).CGColor
        pickerView.layer.borderWidth = 1.0
        pickerView.layer.cornerRadius = 5.0
        parentViewController!.view.addSubview(pickerView)
        
        pickerView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        pickerView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor).active = true
        pickerView.widthAnchor.constraintEqualToConstant(Width.PickerView).active = true
    }
    func configureDoneButton() {
        doneButton = UIButton(type: .Custom)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.exclusiveTouch = true
        doneButton.setTitle(Translation.Done, forState: .Normal)
        doneButton.setTitle(Translation.Done, forState: .Highlighted)
        doneButton.setTitleColor(UIColor.colorFromHexRGB(Color.Blue), forState: .Normal)
        doneButton.setTitleColor(UIColor.colorFromHexRGB(Color.Blue), forState: .Highlighted)
        doneButton.backgroundColor = UIColor.colorFromHexRGB(Color.Gray)
        doneButton.titleLabel?.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.Small)
        doneButton.layer.borderWidth = 1.0
        doneButton.layer.borderColor = UIColor.colorFromHexRGB(Color.Gray).CGColor
        doneButton.layer.cornerRadius = 5.0
        doneButton.isAccessibilityElement = true
        doneButton.addTarget(self, action: Selector(Selectors.Done), forControlEvents: .TouchUpInside)
        parentViewController!.view.addSubview(doneButton)
        
        doneButton.topAnchor.constraintEqualToAnchor(pickerView.bottomAnchor, constant: Padding.Top.Regular).active = true
        doneButton.centerXAnchor.constraintEqualToAnchor(super.view.centerXAnchor).active = true
        doneButton.heightAnchor.constraintEqualToConstant(Height.Button).active = true
        doneButton.widthAnchor.constraintEqualToConstant(Width.LongButton).active = true
    }
    func configureBackgroundView() {
        backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor.colorFromHexRGB(Color.SlateGray)
        backgroundView.alpha = 0.50
        parentViewController!.view.addSubview(backgroundView)
        
        backgroundView.topAnchor.constraintEqualToAnchor(super.view.topAnchor).active = true
        backgroundView.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(backgroundView.trailingAnchor).active = true
        bottomLayoutGuide.topAnchor.constraintEqualToAnchor(backgroundView.bottomAnchor).active = true
    }
}
// MARK: Intenal Action
extension CheckoutViewController {
    func goBack() {
        isExchangeMode = false
        navigationController?.popViewControllerAnimated(true)
    }
    func getCartItem() -> Int {
        return  CartItem.getTotal().cart
    }
    func confirmOrder(sender: UIButton) {
        isExchangeMode = false
        addSpinner()
        CartItem.delete()
        self.performSelector(Selector(Selectors.GotoHome), withObject: self, afterDelay: 0.5)
    }
    func gotoHome() {
        removeSpinner()
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    func receivedNotificationCheckout(notification: NSNotification) {
        if notification.name == Notification.Reload {
            viewDidLoad()
        }
    }
    func addSpinner() {
        spinner.runSpinnerWithIndicator(parentViewController!.view)
        spinner.start()
    }
    func removeSpinner() {
        spinner.stop()
    }
    func gotoCurrencyExchange(sender: UIBarButtonItem) {
        configureBackgroundView()
        configurePickerView()
        configureDoneButton()
    }
    func done(sender: UIButton) {
        if currencyCodeSelected != nil && currencyRateSelected != nil {
            isExchangeMode = true
            addSpinner()
            NSUserDefaults.standardUserDefaults().setValue(currencyCodeSelected, forKey: UserDefaults.CurrencyCode)
            NSUserDefaults.standardUserDefaults().setValue(currencyRateSelected, forKey: UserDefaults.CurrencyRate)
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Reload, object: self)
            self.performSelector(Selector(Selectors.RemoveSpinner), withObject: nil, afterDelay: 0.5)
        }
        pickerView.removeFromSuperview()
        doneButton.removeFromSuperview()
        backgroundView.removeFromSuperview()
    }
}
// MARK:- UIPickerViewDataSource
extension CheckoutViewController: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currency = pickerData[row]
        return currency.code
    }
}
// MARK:- UIPickerViewDelegate
extension CheckoutViewController: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return Width.PickerView
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currency = pickerData[row]
        currencySelectedIndex = row
        currencyCodeSelected = currency.code!
        currencyRateSelected = Double(currency.rate!)
        
        NSUserDefaults.standardUserDefaults().setValue(currencyCodeSelected, forKey: UserDefaults.CurrencyCode)
        NSUserDefaults.standardUserDefaults().setValue(currencyRateSelected, forKey: UserDefaults.CurrencyRate)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
// MARK:- UITableViewDataSource
extension CheckoutViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: CellIdentifier.TableView)
        let cart = tableData[indexPath.row]
        let product = Product.getData(Int(cart.id!))
        let qty = cart.quantity!
        
        var price = Double(product.price!)
        var totalAmount = Double()
        var currencyCode = String()
        var itemNameLabel: UILabel!
        var itemPriceLabel: UILabel!
        var totalLabel: UILabel!
        
        if isExchangeMode {
            price = CurrencyExchange.conversion(Double(price), rate: getDefaultCurrencyExchange().rate!)
            currencyCode = getDefaultCurrencyExchange().code!
        }
        else {
            currencyCode = ConstantKeys.GBP
        }
        totalAmount = Double(qty) * Double(price)
        let totalAmountInString = currencyValueStyle(totalAmount)
        let priceInString = currencyValueStyle(price)

        itemNameLabel = UILabel()
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.text = String(format: "%@ (%@)", product.name!, product.priceInfo!)
        itemNameLabel.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.SuperSmall)
        itemNameLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        itemNameLabel.textAlignment = .Left
        itemNameLabel.numberOfLines = 1
        itemNameLabel.adjustsFontSizeToFitWidth = true
        cell.addSubview(itemNameLabel)
        
        itemNameLabel.topAnchor.constraintEqualToAnchor(cell.topAnchor, constant: Padding.Top.Regular).active = true
        itemNameLabel.leadingAnchor.constraintEqualToAnchor(cell.leadingAnchor, constant: Padding.Left.Table).active = true
        itemNameLabel.widthAnchor.constraintEqualToConstant(Width.LabelTable).active = true
        
        itemPriceLabel = UILabel()
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.text = String(format: "%@ %@ x %@", currencyCode, priceInString, qty)
        itemPriceLabel.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.SuperSmall)
        itemPriceLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        itemPriceLabel.textAlignment = .Left
        itemPriceLabel.numberOfLines = 1
        itemPriceLabel.adjustsFontSizeToFitWidth = true
        cell.addSubview(itemPriceLabel)
        
        itemPriceLabel.topAnchor.constraintEqualToAnchor(itemNameLabel.bottomAnchor, constant: 3).active = true
        itemPriceLabel.leadingAnchor.constraintEqualToAnchor(itemNameLabel.leadingAnchor).active = true
        itemPriceLabel.widthAnchor.constraintEqualToAnchor(itemNameLabel.widthAnchor).active = true

        totalLabel = UILabel()
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.text = String(format: "%@ %@", currencyCode, totalAmountInString)
        totalLabel.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.SuperSmall)
        totalLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        totalLabel.textAlignment = .Right
        totalLabel.numberOfLines = 1
        totalLabel.adjustsFontSizeToFitWidth = true
        cell.addSubview(totalLabel)
        
        totalLabel.centerYAnchor.constraintEqualToAnchor(cell.centerYAnchor).active = true
        cell.trailingAnchor.constraintEqualToAnchor(totalLabel.trailingAnchor, constant: Padding.Right.Table).active = true
        totalLabel.widthAnchor.constraintEqualToConstant(120).active = true
        
        cell.exclusiveTouch = true
        cell.selectionStyle = .None
        cell.setNeedsDisplay()
        cell.layoutIfNeeded()
        cell.setNeedsUpdateConstraints()
        return cell
    }
}
// MARK:- UITableViewDelegate
extension CheckoutViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Height.BasketCell
    }
}