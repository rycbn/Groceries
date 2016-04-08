//
//  ProductDetailViewController.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit
import CoreData

class ProductDetailViewController: UIViewController {

    // MARK: Properties
    var itemData: Product!
    var cartData: CartItem!
    var itemNameLabel: UILabel!
    var itemPriceLabel: UILabel!
    var addToBasketButton: UIButton!
    var quantityButton: UIButton!
    var addQtyAlertAction: UIAlertAction!
    
    var spinner = CustomSpinner()
    var qtyString = String()
    var isEditMode = Bool()
    var isValidQty = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFetchData()
        configureLeftBarButtonItem()
        configureRightBarButtonItem()
        configureNavigationBar()
        configureItemNameLabel()
        configureItemPriceLabel()
        configureQuantityButton()
        configureAddToBasketButton()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.Reload, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.ProductDetail), name: Notification.Reload, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.ProductDetailInsertCurrencyExchangeCompleted, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.ProductDetail), name: Notification.ProductDetailInsertCurrencyExchangeCompleted, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.ProductDetailInsertCurrencyExchangeFailed, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.ProductDetail), name: Notification.ProductDetailInsertCurrencyExchangeFailed, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Notification.ProductDetailCurrencyExchangeNoChange, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector(Selectors.ReceivedNotification.ProductDetail), name: Notification.ProductDetailCurrencyExchangeNoChange, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
// MARK:- UI Configuration
extension ProductDetailViewController {
    func configureFetchData() {
        let fetchRequest = NSFetchRequest(entityName: EntityName.CartItem)
        fetchRequest.predicate = NSPredicate(format: "id = %@", itemData.id!)
        do {
            let results = try appDelegate().coreDataStack.context.executeFetchRequest(fetchRequest) as! [CartItem]
            if results.count > 0 {
                cartData = results.first!
                qtyString = String(cartData.quantity!)
            }
            else {
                qtyString = "1"
            }
        }
        catch let error as NSError {
            print("Error: \(error)" + "description: \(error.localizedDescription)")
        }
        //cartData = CartItem.getData(Int(itemData.id!)).0
        //qtyString = CartItem.getData(Int(itemData.id!)).1
    }
    func configureNavigationBar() {
        title = String(format: "%@: (%li)", Translation.TotalGroceries, CartItem.getTotal().cart)
    }
    func configureLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = backBarButtonItem(target: self)
    }
    func configureRightBarButtonItem() {
        navigationItem.rightBarButtonItem = basketBarButtonItem(target: self)
    }
    func configureItemNameLabel() {
        itemNameLabel = UILabel()
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.text = String(format: "%@ (%@)", itemData.name!, itemData.priceInfo!)
        itemNameLabel.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.SuperSmall)
        itemNameLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        itemNameLabel.textAlignment = .Left
        itemNameLabel.numberOfLines = 1
        itemNameLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(itemNameLabel)
        
        itemNameLabel.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor, constant: Padding.Top.Regular).active = true
        itemNameLabel.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor, constant: Padding.Left.Regular).active = true
        itemNameLabel.widthAnchor.constraintEqualToConstant(Width.LabelRegular).active = true
    }
    func configureItemPriceLabel() {
        itemPriceLabel = UILabel()
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.text = String(format: "%@ %@", ConstantKeys.GBP, currencyValueStyle(Double(itemData.price!)))
        itemPriceLabel.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.SuperSmall)
        itemPriceLabel.textColor = UIColor.colorFromHexRGB(Color.SlateGray)
        itemPriceLabel.textAlignment = .Left
        itemPriceLabel.numberOfLines = 1
        itemPriceLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(itemPriceLabel)
        
        itemPriceLabel.topAnchor.constraintEqualToAnchor(itemNameLabel.bottomAnchor, constant: 3).active = true
        itemPriceLabel.leadingAnchor.constraintEqualToAnchor(itemNameLabel.leadingAnchor).active = true
        itemPriceLabel.widthAnchor.constraintEqualToAnchor(itemNameLabel.widthAnchor).active = true
    }
    func configureQuantityButton() {
        quantityButton = UIButton(type: .Custom)
        quantityButton.translatesAutoresizingMaskIntoConstraints = false
        quantityButton.exclusiveTouch = true
        quantityButton.setTitle(String(format:"%@: %@", ConstantKeys.Qty, qtyString), forState: .Normal)
        quantityButton.setTitle(String(format:"%@: %@", ConstantKeys.Qty, qtyString), forState: .Highlighted)
        quantityButton.setImage(qtyImage(), forState: .Normal)
        quantityButton.setImage(qtyImage(), forState: .Highlighted)
        quantityButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Normal)
        quantityButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Highlighted)
        quantityButton.backgroundColor = UIColor.colorFromHexRGB(Color.Blue)
        quantityButton.titleLabel?.font = UIFont(name: FontNameCalibri.Regular, size: FontSize.Tiny)
        quantityButton.layer.borderWidth = 1.0
        quantityButton.layer.borderColor = UIColor.colorFromHexRGB(Color.Blue).CGColor
        quantityButton.layer.cornerRadius = 5.0
        quantityButton.isAccessibilityElement = true
        quantityButton.tintColor = UIColor.colorFromHexRGB(Color.White)
        if qtyString == "0" {
            quantityButton.addTarget(self, action: Selector(Selectors.AddQty), forControlEvents: .TouchUpInside)
        }
        else {
            quantityButton.addTarget(self, action: Selector(Selectors.EditQty), forControlEvents: .TouchUpInside)
        }
        view.addSubview(quantityButton)
        
        quantityButton.topAnchor.constraintEqualToAnchor(itemNameLabel.topAnchor).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(quantityButton.trailingAnchor, constant: Padding.Right.Regular).active = true
        quantityButton.heightAnchor.constraintEqualToConstant(Height.SmallButton).active = true
        quantityButton.widthAnchor.constraintEqualToConstant(Width.Button).active = true
    }
    func configureAddToBasketButton() {
        addToBasketButton = UIButton(type: .Custom)
        addToBasketButton.translatesAutoresizingMaskIntoConstraints = false
        addToBasketButton.exclusiveTouch = true
        addToBasketButton.setTitle(Translation.AddToBasket, forState: .Normal)
        addToBasketButton.setTitle(Translation.AddToBasket, forState: .Highlighted)
        addToBasketButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Normal)
        addToBasketButton.setTitleColor(UIColor.colorFromHexRGB(Color.White), forState: .Highlighted)
        addToBasketButton.backgroundColor = UIColor.colorFromHexRGB(Color.Blue)
        addToBasketButton.titleLabel?.font = UIFont(name: FontNameCalibri.Bold, size: FontSize.Small)
        addToBasketButton.layer.borderWidth = 1.0
        addToBasketButton.layer.borderColor = UIColor.colorFromHexRGB(Color.Blue).CGColor
        addToBasketButton.layer.cornerRadius = 5.0
        addToBasketButton.isAccessibilityElement = true
        addToBasketButton.addTarget(self, action: Selector(Selectors.AddToBasket), forControlEvents: .TouchUpInside)
        if qtyString == "0" {
            addToBasketButton.enabled = false
            addToBasketButton.alpha = 0.5
        }
        view.addSubview(addToBasketButton)
        
        addToBasketButton.topAnchor.constraintEqualToAnchor(quantityButton.bottomAnchor, constant: (Padding.Top.Regular * 2)).active = true
        addToBasketButton.leadingAnchor.constraintEqualToAnchor(super.view.leadingAnchor, constant: Padding.Left.Regular).active = true
        super.view.trailingAnchor.constraintEqualToAnchor(addToBasketButton.trailingAnchor, constant: Padding.Right.Regular).active = true
        addToBasketButton.heightAnchor.constraintEqualToConstant(45).active = true
    }
}
// MARK:- Internal Action
extension ProductDetailViewController {
    func receivedNotificationProductDetail(notification: NSNotification) {
        if notification.name == Notification.Reload {
            viewDidLoad()
        }
        else if (notification.name == Notification.ProductDetailInsertCurrencyExchangeCompleted) || (notification.name == Notification.ProductDetailCurrencyExchangeNoChange) {
            removeSpinner()
            let pushVC = UIStoryboard.basketViewController() as BasketViewController!
            navigationController?.pushViewController(pushVC, animated: true)
        }
        else if notification.name == Notification.ProductDetailInsertCurrencyExchangeFailed {
            removeSpinner()
            displayAlertWithTitle(Translation.ApiErrorTitle, message: Translation.ApiErrorMessage, viewController: self)
        }
    }
    func addOverlayWithMessage(message message: String) {
        spinner.runSpinnerWithMessage(parentViewController!.view, message: message)
    }
    func removeOverlay() {
        spinner.dismiss()
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
            groceries.getCurrencyExchangeFromAPI(source: ConstantKeys.ProductDetail)
        }
        else {
            displayAlertWithTitle(Translation.NetworkErrorTitle, message: Translation.NetworkErrorMessage, viewController: self)
        }
    }
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    func addToBasket(sender: UIButton) {
        addSpinner()
        let cartItemEntity = NSEntityDescription.entityForName(EntityName.CartItem, inManagedObjectContext: appDelegate().coreDataStack.context)
        let fetchRequest = NSFetchRequest(entityName: EntityName.CartItem)
        fetchRequest.predicate = NSPredicate(format: "id = %@", itemData.id!)
        do {
            let results = try appDelegate().coreDataStack.context.executeFetchRequest(fetchRequest) as! [CartItem]
            if results.count > 0 {
                cartData = results.first!
                if isEditMode {
                    cartData.quantity = Int(qtyString)!
                    removeSpinner()
                    addOverlayWithMessage(message: Translation.AddedToBasket)
                    appDelegate().coreDataStack.saveContext()
                    NSNotificationCenter.defaultCenter().postNotificationName(Notification.Reload, object: self)
                    self.performSelector(Selector(Selectors.RemoveOverlay), withObject: nil, afterDelay: 0.5)
                    isEditMode = false
                }
                else {
                    var totalQty = 0
                    totalQty = Int(cartData.quantity!) + Int(qtyString)!
                    isValidQty = validateQuantity(String(totalQty))
                    if isValidQty {
                        removeSpinner()
                        addOverlayWithMessage(message: Translation.AddedToBasket)
                        cartData.quantity = totalQty
                        appDelegate().coreDataStack.saveContext()
                        NSNotificationCenter.defaultCenter().postNotificationName(Notification.Reload, object: self)
                        self.performSelector(Selector(Selectors.RemoveOverlay), withObject: nil, afterDelay: 0.5)
                    }
                    else {
                        removeSpinner()
                        displayAlertWithTitle(Translation.QuantityErrorTitle, message: Translation.Maximum99, viewController: self)
                    }
                }
            }
            else {
                let item = CartItem(entity: cartItemEntity!, insertIntoManagedObjectContext: appDelegate().coreDataStack.context)
                item.id = itemData.id!
                item.amount = itemData.price!
                item.quantity = Int(qtyString)

                removeSpinner()
                addOverlayWithMessage(message: Translation.AddedToBasket)
                appDelegate().coreDataStack.saveContext()
                NSNotificationCenter.defaultCenter().postNotificationName(Notification.Reload, object: self)
                self.performSelector(Selector(Selectors.RemoveOverlay), withObject: nil, afterDelay: 0.5)
            }
        }
        catch let error as NSError {
            print("Error: \(error)" + "description: \(error.localizedDescription)")
        }
    }
    func addQty(sender: UIButton) {
        var qtyTextField = UITextField()
        let alert = UIAlertController(title: Translation.PleaseAddQuantity, message: Translation.Maximum99, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.placeholder = Translation.Quantity
            textField.keyboardType = .NumberPad
        }
        addQtyAlertAction = UIAlertAction(title: Translation.Add, style: .Default) { (action:UIAlertAction) -> Void in
            self.qtyString = qtyTextField.text!
            let qty = String(format: "%@: %li", ConstantKeys.Qty, Int(self.qtyString)!)
            self.quantityButton.setTitle(qty, forState: .Normal)
        }
        addQtyAlertAction.enabled = false

        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object:alert.textFields?[0],
            queue: NSOperationQueue.mainQueue()) {_ in
                qtyTextField = alert.textFields![0]
                var isValid = false
                if !qtyTextField.text!.isEmpty && qtyTextField.text!.characters.count < 3 && validateQuantity(qtyTextField.text!) {
                    isValid = true
                }
                self.addToBasketButton.alpha = isValid ? 1.0 : 0.5
                self.addQtyAlertAction.enabled = isValid
                self.addToBasketButton.enabled = isValid
        }
        let cancelAction = UIAlertAction(title: Translation.Cancel, style: .Cancel, handler: nil)
        alert.addAction(addQtyAlertAction)
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func editQty(sender: UIButton) {
        self.isEditMode = false
        var qtyTextField = UITextField()
        let alert = UIAlertController(title: Translation.PleaseEditQuantity, message: Translation.Maximum99, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField) -> Void in
            textField.text = self.qtyString
            textField.keyboardType = .NumberPad
        }
        addQtyAlertAction = UIAlertAction(title: Translation.Save, style: .Default) { (action:UIAlertAction) -> Void in
            self.isEditMode = true
            self.qtyString = qtyTextField.text!
            let qty = String(format: "%@: %li", ConstantKeys.Qty, Int(self.qtyString)!)
            self.quantityButton.setTitle(qty, forState: .Normal)
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
// MARK: GroceriesDelegate
extension ProductDetailViewController: GroceriesDelegate {
    func ApiError() {
        removeSpinner()
        displayAlertWithTitle(Translation.ApiErrorTitle, message: Translation.ApiErrorMessage, viewController: self)
    }
}