//
//  BasketViewController.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreData

class BasketViewController: UIViewController {

    // MARK: Properties
    var addQtyAlertAction: UIAlertAction!

    var tableView = UITableView()
    var divLabel = UILabel()
    var emptyHeaderLabel = UILabel()
    var headerLabel = UILabel()
    var checkoutButton = UIButton(type: .Custom)
    var continueButton = UIButton(type: .Custom)
    var tableData = [CartItem]()
    var spinner = CustomSpinner()
    var pickerData = [CurrencyExchange]()
    var currencySelectedIndex = NSInteger()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        configureFetchData()
        configureNavigationBar()
        configureLeftBarButtonItem()
        if getCartItem() == 0 {
            headerLabel.removeFromSuperview()
            checkoutButton.removeFromSuperview()
            configureEmptyHeaderLabel()
            configureContinueButton()
        }
        else {
            emptyHeaderLabel.removeFromSuperview()
            continueButton.removeFromSuperview()
            configureHeaderLabel()
            configureCheckoutButton()
        }
        configureDivLabel()
        configureTableView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.Reload, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.Basket), name: Notification.Reload, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK: UI Configuration
extension BasketViewController {
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
    }
    func configureNavigationBar() {
        title = Translation.Groceries
    }
    func configureLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = backBarButtonItem(target: self)
    }
    func configureEmptyHeaderLabel() {
        emptyHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyHeaderLabel.text = Translation.ShoppingBasketEmpty
        emptyHeaderLabel.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.SuperSmall)
        emptyHeaderLabel.textColor = UIColor.colorFromHexRGB(Color.Red)
        emptyHeaderLabel.textAlignment = .Left
        emptyHeaderLabel.numberOfLines = 1
        emptyHeaderLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(emptyHeaderLabel)
        
        emptyHeaderLabel.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor).active = true
        emptyHeaderLabel.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor, constant: Padding.Left.Regular).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(emptyHeaderLabel.trailingAnchor, constant: Padding.Right.Regular).active = true
        emptyHeaderLabel.heightAnchor.constraintEqualToConstant(35).active = true
    }
    func configureContinueButton() {
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.exclusiveTouch = true
        continueButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Normal)
        continueButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Highlighted)
        continueButton.backgroundColor = UIColor.colorFromHexRGB(Color.Blue)
        continueButton.titleLabel?.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.Small)
        continueButton.layer.borderWidth = 1.0
        continueButton.layer.borderColor = UIColor.colorFromHexRGB(Color.Blue).CGColor
        continueButton.layer.cornerRadius = 5.0
        continueButton.isAccessibilityElement = true
        continueButton.setTitle(Translation.ContinueShopping, forState: .Normal)
        continueButton.addTarget(self, action: Selector(Selectors.ContinueShopping), forControlEvents: .TouchUpInside)
        view.addSubview(continueButton)
        
        continueButton.topAnchor.constraintEqualToAnchor(emptyHeaderLabel.bottomAnchor).active = true
        continueButton.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor, constant: Padding.Left.Regular).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(continueButton.trailingAnchor, constant: Padding.Right.Regular).active = true
        continueButton.heightAnchor.constraintEqualToConstant(Height.Button).active = true
    }
    func configureHeaderLabel() {
        func getItemString() -> String {
            return CartItem.getTotal().0 == 1 ? Translation.Item.lowercaseString : Translation.Items.lowercaseString
        }
        let totalItem = CartItem.getTotal().cart
        let totalAmount = CartItem.getTotal().amount
        let currencyCode = ConstantKeys.GBP
        let totalAmountInString = currencyValueStyle(totalAmount)
    
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = String(format: "%@ (%li %@): %@ %@", Translation.BasketSubtotal, totalItem, getItemString(), currencyCode, totalAmountInString)
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
    func configureCheckoutButton() {
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        checkoutButton.exclusiveTouch = true
        checkoutButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Normal)
        checkoutButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Highlighted)
        checkoutButton.backgroundColor = UIColor.colorFromHexRGB(Color.Blue)
        checkoutButton.titleLabel?.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.Small)
        checkoutButton.layer.borderWidth = 1.0
        checkoutButton.layer.borderColor = UIColor.colorFromHexRGB(Color.Blue).CGColor
        checkoutButton.layer.cornerRadius = 5.0
        checkoutButton.isAccessibilityElement = true
        checkoutButton.setTitle(Translation.ProceedToCheckout, forState: .Normal)
        checkoutButton.setTitle(Translation.ProceedToCheckout, forState: .Highlighted)
        checkoutButton.addTarget(self, action: Selector(Selectors.ProceedCheckout), forControlEvents: .TouchUpInside)
        view.addSubview(checkoutButton)
        
        checkoutButton.topAnchor.constraintEqualToAnchor(headerLabel.bottomAnchor).active = true
        checkoutButton.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor, constant: Padding.Left.Regular).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(checkoutButton.trailingAnchor, constant: Padding.Right.Regular).active = true
        checkoutButton.heightAnchor.constraintEqualToConstant(Height.Button).active = true
    }
    func configureDivLabel() {
        divLabel.translatesAutoresizingMaskIntoConstraints = false
        divLabel.backgroundColor = UIColor.colorFromHexRGB(Color.LightGray)
        view.addSubview(divLabel)
        if getCartItem() == 0 {
            divLabel.topAnchor.constraintEqualToAnchor(continueButton.bottomAnchor, constant: Padding.Top.RegularHalf).active = true
        }
        else {
            divLabel.topAnchor.constraintEqualToAnchor(checkoutButton.bottomAnchor, constant: Padding.Top.RegularHalf).active = true
        }
        divLabel.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(divLabel.trailingAnchor).active = true
        divLabel.heightAnchor.constraintEqualToConstant(1).active = true
    }
    func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.opaque = true
        tableView.clearsContextBeforeDrawing = true
        tableView.clipsToBounds = true
        tableView.autoresizesSubviews = true
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.multipleTouchEnabled = false
        tableView.allowsMultipleSelection = false
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier.TableView)
        view.addSubview(tableView)
        
        tableView.topAnchor.constraintEqualToAnchor(divLabel.bottomAnchor, constant: Padding.Top.RegularHalf).active = true
        tableView.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(tableView.trailingAnchor).active = true
        bottomLayoutGuide.topAnchor.constraintEqualToAnchor(tableView.bottomAnchor).active = true
    }
}
// MARK: Intenal Action
extension BasketViewController {
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    func getCartItem() -> Int {
        return  CartItem.getTotal().cart
    }
    func proceedCheckout(sender: UIButton) {
        let pushVC = UIStoryboard.checkoutViewController() as CheckoutViewController!
        navigationController?.pushViewController(pushVC, animated: true)
    }
    func continueShopping(sender: UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    func receivedNotificationBasket(notification: NSNotification) {
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
    func addOverlayWithMessage(message message: String) {
        spinner.runSpinnerWithMessage(parentViewController!.view, message: message)
    }
    func removeOverlay() {
        spinner.dismiss()
    }
    func deleteCartItem(sender: UIButton) {
        addOverlayWithMessage(message: Translation.PleaseWait)

        let indexPath = NSIndexPath(forRow: sender.tag, inSection: 0)
        let dataObj = tableData[indexPath.row] as NSManagedObject

        CartItem.deleteCart(dataObj)
        
        tableData.removeAtIndex(indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()

        NSNotificationCenter.defaultCenter().postNotificationName(Notification.Reload, object: self)
        self.performSelector(Selector(Selectors.RemoveOverlay), withObject: nil, afterDelay: 0.5)
    }
    func editQty(sender: UIButton) {
        let tag = sender.tag
        let cartData = CartItem.getData(tag).data
        var qtyTextField = UITextField()
        let alert = UIAlertController(title: Translation.PleaseEditQuantity, message: Translation.Maximum99, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.text = String(cartData!.quantity!)
            textField.keyboardType = .NumberPad
        }
        addQtyAlertAction = UIAlertAction(title: Translation.Save, style: .Default) { (action:UIAlertAction) -> Void in
            self.addOverlayWithMessage(message: Translation.PleaseWait)
            let qtyString = qtyTextField.text!
            CartItem.updateCartQty(tag, qty: Int(qtyString)!)
            NSNotificationCenter.defaultCenter().postNotificationName(Notification.Reload, object: self)
            self.performSelector(Selector(Selectors.RemoveOverlay), withObject: nil, afterDelay: 0.5)
        }
        addQtyAlertAction.enabled = false
        
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object:alert.textFields?[0],
            queue: NSOperationQueue.mainQueue()) {_ in
                qtyTextField = alert.textFields![0]
                var isValid = false
                if !qtyTextField.text!.isEmpty && qtyTextField.text!.characters.count < 3 && validateQuantity(qtyTextField.text!) {
                    isValid = true
                }
                self.addQtyAlertAction.enabled = isValid
        }
        let cancelAction = UIAlertAction(title: Translation.Cancel, style: .Cancel, handler: nil)
        alert.addAction(addQtyAlertAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
// MARK:- UITableViewDataSource, UITableViewDelegate
extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Height.BasketCell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: CellIdentifier.TableView)
        let cart = tableData[indexPath.row]
        let product = Product.getData(Int(cart.id!))
        
        var itemNameLabel: UILabel!
        var itemPriceLabel: UILabel!
        var quantityButton: UIButton!
        var deleteButton: UIButton!

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
        itemPriceLabel.text = String(format: "%@ %@", ConstantKeys.GBP, currencyValueStyle(Double(product.price!)))
        itemPriceLabel.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.SuperSmall)
        itemPriceLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        itemPriceLabel.textAlignment = .Left
        itemPriceLabel.numberOfLines = 1
        itemPriceLabel.adjustsFontSizeToFitWidth = true
        cell.addSubview(itemPriceLabel)
        
        itemPriceLabel.topAnchor.constraintEqualToAnchor(itemNameLabel.bottomAnchor, constant: 3).active = true
        itemPriceLabel.leadingAnchor.constraintEqualToAnchor(itemNameLabel.leadingAnchor).active = true
        itemPriceLabel.widthAnchor.constraintEqualToAnchor(itemNameLabel.widthAnchor).active = true

        quantityButton = UIButton(type: .Custom)
        quantityButton.translatesAutoresizingMaskIntoConstraints = false
        quantityButton.exclusiveTouch = true
        quantityButton.setTitle(String(format:"%@: %@", ConstantKeys.Qty, cart.quantity!), forState: .Normal)
        quantityButton.setTitle(String(format:"%@: %@", ConstantKeys.Qty, cart.quantity!), forState: .Highlighted)
        quantityButton.setImage(qtyImage(), forState: .Normal)
        quantityButton.setImage(qtyImage(), forState: .Highlighted)
        quantityButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Normal)
        quantityButton.setTitleColor(UIColor.colorFromHexRGB(Color.SlateGray), forState: .Highlighted)
        quantityButton.backgroundColor = UIColor.colorFromHexRGB(Color.Blue)
        quantityButton.titleLabel?.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.Tiny)
        quantityButton.layer.borderWidth = 1.0
        quantityButton.layer.borderColor = UIColor.colorFromHexRGB(Color.Blue).CGColor
        quantityButton.layer.cornerRadius = 5.0
        quantityButton.isAccessibilityElement = true
        quantityButton.tintColor = UIColor.colorFromHexRGB(Color.White)
        quantityButton.tag = Int(cart.id!)
        quantityButton.addTarget(self, action: Selector(Selectors.EditQty), forControlEvents: .TouchUpInside)
        cell.addSubview(quantityButton)
        
        quantityButton.topAnchor.constraintEqualToAnchor(itemNameLabel.topAnchor).active = true
        cell.trailingAnchor.constraintEqualToAnchor(quantityButton.trailingAnchor, constant: Padding.Right.Table).active = true
        quantityButton.heightAnchor.constraintEqualToConstant(Height.SmallButton).active = true
        quantityButton.widthAnchor.constraintEqualToConstant(Width.Button).active = true
    
        deleteButton = UIButton(type: .Custom)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.exclusiveTouch = true
        deleteButton.setTitle(Translation.Delete, forState: .Normal)
        deleteButton.setTitle(Translation.Delete, forState: .Highlighted)
        deleteButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Normal)
        deleteButton.setTitleColor(UIColor.colorFromHexRGB(Color.SlateGray), forState: .Highlighted)
        deleteButton.backgroundColor = UIColor.colorFromHexRGB(Color.Blue)
        deleteButton.titleLabel?.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.Tiny)
        deleteButton.layer.borderWidth = 1.0
        deleteButton.layer.borderColor = UIColor.colorFromHexRGB(Color.Blue).CGColor
        deleteButton.layer.cornerRadius = 5.0
        deleteButton.isAccessibilityElement = true
        deleteButton.tintColor = UIColor.colorFromHexRGB(Color.White)
        deleteButton.tag = indexPath.row
        deleteButton.addTarget(self, action: Selector(Selectors.DeleteCartItem), forControlEvents: .TouchUpInside)
        cell.addSubview(deleteButton)
        
        deleteButton.topAnchor.constraintEqualToAnchor(quantityButton.topAnchor).active = true
        deleteButton.leadingAnchor.constraintEqualToAnchor(itemPriceLabel.trailingAnchor, constant: Padding.Right.RegularHalf).active = true
        deleteButton.heightAnchor.constraintEqualToConstant(Height.SmallButton).active = true
        deleteButton.widthAnchor.constraintEqualToConstant(Width.Button).active = true
        
        cell.exclusiveTouch = true
        cell.selectionStyle = .None
        cell.setNeedsDisplay()
        cell.setNeedsLayout()
        cell.setNeedsUpdateConstraints()
        return cell
    }
}