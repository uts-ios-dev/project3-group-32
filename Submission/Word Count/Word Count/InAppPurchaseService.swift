//
//  InAppPurchaseService.swift
//  Word Count
//
//  Created by Clint Sellen on 4/6/18.
//  Copyright © 2018 UTS. All rights reserved.
//
//reference: https://www.youtube.com/watch?v=o3hJ0rY1NNw -> https://www.kiloloco.com/p/youtube
//

import Foundation
import StoreKit

class InAppPurchasesService: NSObject {
    private override init() {}
    static let shared = InAppPurchasesService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products: Set = [IAPProduct.AnimalWordList.rawValue, IAPProduct.ScienceWordList.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct){
        guard let productToPurchase = products.filter( { $0.productIdentifier == product.rawValue }).first else { return }
        let payment  = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchases() {
        print("Restoring Purchases")
        paymentQueue.restoreCompletedTransactions()
    }
}

extension InAppPurchasesService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
       self.products = response.products
        print("IAPProducts \(response.products)")
        for product in response.products {
            print(product.productIdentifier)
        }
    }
}

extension InAppPurchasesService: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing: break
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status () -> String {
        switch self {
        case .deferred: return("Purchaase Deferred")
        case .failed: return("Purchase Failed")
        case .purchased: return("Purchase Complete")
        case .restored: return("Purchased Restored")
        case .purchasing: return ("Purchasing")
        }
    }
}
