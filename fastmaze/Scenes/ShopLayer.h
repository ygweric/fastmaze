//
//  ShopLayer.h
//  fastmaze
//
//  Created by Eric on 13-2-27.
//
//

#import "CCLayer.h"
#import <StoreKit/StoreKit.h>
@interface ShopLayer : MyBaseLayer <SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    int iapId;
}
+(CCScene *) scene;
@end
