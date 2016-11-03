//
//  FuncBarButton.swift
//  Groceries
//
//  Created by Roger Yong on 22/03/2016.
//  Copyright © 2016 rycbn. All rights reserved.
//

import UIKit

func basketBarButtonItem(target viewController: UIViewController) -> UIBarButtonItem {
    let barButtonItem = UIBarButtonItem(image: cartImage(), style: .Plain, target: viewController, action: Selector(Selectors.GotoBasket))
    return barButtonItem
}

func backBarButtonItem(target viewController: UIViewController) -> UIBarButtonItem {
    let barButtonItem = UIBarButtonItem(image: backImage(), style: .Plain, target: viewController, action: Selector(Selectors.GoBack))
    return barButtonItem
}

func exchangeBarButtonItem(target viewController: UIViewController) -> UIBarButtonItem {
    let barButtonItem = UIBarButtonItem(image: exchangeImage(), style: .Plain, target: viewController, action: Selector(Selectors.GotoCurrencyExchange))
    return barButtonItem
}
