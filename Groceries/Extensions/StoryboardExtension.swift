//
//  StoryboardExtension.swift
//  Groceries
//
//  Created by Roger Yong on 19/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

internal extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard {
        return UIStoryboard(name: StoryboardIdentifier.Main, bundle: NSBundle.mainBundle())
    }
    class func productViewController() -> ProductViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier(StoryboardIdentifier.Product) as? ProductViewController
    }
    class func productDetailViewController() -> ProductDetailViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier(StoryboardIdentifier.ProductDetail) as? ProductDetailViewController
    }
    class func basketViewController() -> BasketViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier(StoryboardIdentifier.Basket) as? BasketViewController
    }
    class func checkoutViewController() -> CheckoutViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier(StoryboardIdentifier.Checkout) as? CheckoutViewController
    }
}
