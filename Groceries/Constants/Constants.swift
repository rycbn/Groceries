//
//  Constants.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

struct StoryboardIdentifier {
    static let Main = "Main"
    static let Product = "ProductStoryboardId"
    static let ProductDetail = "ProductDetailStoryboardId"
    static let Basket = "BasketStoryboardId"
    static let Checkout = "CheckoutStoryboardId"
}

struct CellIdentifier {
    static let TableView = "TableViewCell"
}

struct Selectors {
    static let GoBack = "goBack"
    static let GotoBasket = "gotoBasket:"
    static let AddQty = "addQty:"
    static let EditQty = "editQty:"
    static let AddToBasket = "addToBasket:"
    static let ProceedCheckout = "proceedCheckout:"
    static let ConfirmOrder = "confirmOrder:"
    static let ContinueShopping = "continueShopping:"
    static let GotoCurrencyExchange = "gotoCurrencyExchange:"
    static let DeleteCartItem = "deleteCartItem:"
    static let Done = "done:"
    static let RemoveSpinner = "removeSpinner"
    static let RemoveOverlay = "removeOverlay"
    static let GotoHome = "gotoHome"

    struct ReceivedNotification {
        static let ProductDetail = "receivedNotificationProductDetail:"
        static let Product = "receivedNotificationProduct:"
        static let Basket = "receivedNotificationBasket:"
        static let Checkout = "receivedNotificationCheckout:"
    }
}

struct UserDefaults {
    static let CurrencyDownloadDate = "currencyDownloadDate"
    static let CurrencyCode = "currencyCode"
    static let CurrencyRate = "currencyRate"
    static let BaseCurrencyRate = "baseCurrencyRate"
}

struct EntityName {
    static let Product = "Product"
    static let CurrencyExchange = "CurrencyExchange"
    static let CartItem = "CartItem"
}

struct Notification {
    static let Reload = "ReloadViewController"
    static let ProductInsertCurrencyExchangeCompleted = "ProductInsertCurrencyExchangeCompleted"
    static let ProductInsertCurrencyExchangeFailed = "ProductInsertCurrencyExchangeFailed"
    static let ProductCurrencyExchangeNoChange = "ProductCurrencyExchangeNoChange"
    static let ProductDetailInsertCurrencyExchangeCompleted = "ProductDetailInsertCurrencyExchangeCompleted"
    static let ProductDetailInsertCurrencyExchangeFailed = "ProductDetailInsertCurrencyExchangeFailed"
    static let ProductDetailCurrencyExchangeNoChange = "ProductDetailCurrencyExchangeNoChange"
}

struct ConstantKeys {
    static let GBP = "GBP"
    static let Qty = "Qty"
    static let Product = "Product"
    static let ProductDetail = "ProductDetail"
}
