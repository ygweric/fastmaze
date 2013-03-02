//
//  ShopLayer.m
//  fastmaze
//
//  Created by Eric on 13-2-27.
//
//

#import "ShopLayer.h"
#import "MenuLayer.h"

#define IAP_REMOVE_AD @"fastmaze.removead"

@implementation ShopLayer 



+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    ShopLayer *layer = [ShopLayer node];
    [scene addChild: layer];
    return scene;
}
-(id)init{
    if(self=[super init]){
        if (IS_IPHONE_5) {
            [self setBg:@"bg-568h@2x.jpg"];
        }else{
            [self setBg:@"removead_bg.png"];
        }

        CCMenu* menuRemoveAd= [SpriteUtil createMenuWithImg:@"removead_bt.png" pressedColor:ccYELLOW target:self selector:@selector(removeAd)];
        [self addChild:menuRemoveAd];
        menuRemoveAd.position=ccp(600,350);
        
        CCMenu* menuBack= [SpriteUtil createMenuWithImg:@"button_previous.png" pressedColor:ccYELLOW target:self selector:@selector(backCallback:)];
        [self addChild:menuBack];
        menuBack.position=ccp(150,winSize.height-100);
        //----observer transaction
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
-(void) backCallback: (id) sender
{
	[AudioUtil displayAudioButtonClick];
	[[CCDirector sharedDirector] replaceScene:  [CCTransitionSplitRows transitionWithDuration:1.0f scene:[MenuLayer scene]]];
}

-(void)removeAd{
    iapId=IAP_REMOVE_AD;
    if ([SKPaymentQueue canMakePayments]) {
        //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        [self RequestProductData];
        NSLog(@"---allow In-App Purchase");
    }
    else
    {
        NSLog(@"--not allow In-App Purchas");
        UIAlertView *alerView =  [[[UIAlertView alloc] initWithTitle:nil message:@"Your device doesn't allow  In-App Purchase" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
        [alerView show];
        
    }
}
#pragma mark request product
-(void)RequestProductData
{
    CCLOG(@"---------RequestProductData");
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject:iapId]];
    request.delegate=self;
    [request start];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------productsRequest:didReceiveResponse");
    NSArray *myProduct = response.products;
    NSLog(@"Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"Product count: %d", [myProduct count]);
    // populate UI
    SKProduct* productToBuy=nil;
    for(SKProduct *product in myProduct){
        NSLog(@"---product info-------");
        NSLog(@"SKProduct description%@", [product description]);
        NSLog(@"title %@" , product.localizedTitle);
        NSLog(@"localizedDescription: %@" , product.localizedDescription);
        NSLog(@"price: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        if ([product.productIdentifier isEqualToString:iapId]) {
            productToBuy=product;
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:productToBuy];
     CCLOG(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}
- (void)requestProUpgradeProductData
{
    CCLOG(@"------请求升级数据---------");
    NSSet *productIdentifiers = [NSSet setWithObject:@"com.productid"];
    SKProductsRequest* productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
    
}
//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    CCLOG(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    [alerView release];
}

-(void) requestDidFinish:(SKRequest *)request
{
    NSLog(@"----------反馈信息结束--------------");
    
}
-(void) PurchasedTransaction: (SKPaymentTransaction *)transaction{
    CCLOG(@"-----PurchasedTransaction----");
    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
    [transactions release];
}
#pragma mark observer transaction
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    CCLOG(@"-----paymentQueue:updatedTransactions---transactions:%@",transactions);
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                [self completeTransaction:transaction];
                CCLOG(@"Purchase Success --------");
               
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                CCLOG(@"Purchase Failed --------");
               break;
            case SKPaymentTransactionStateRestored://已经购买过该商品
                [self restoreTransaction:transaction];
                CCLOG(@"-----已经购买过该商品 --------");
            case SKPaymentTransactionStatePurchasing:      //商品添加进列表
                CCLOG(@"-----商品添加进列表 --------");
                break;
            default:
                break;
        }
    }
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    CCLOG(@"completeTransaction--------");
    UIAlertView *alerView =  [[[UIAlertView alloc] initWithTitle:nil
                                                         message:@"Purchase Succesfully"
                                                        delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil]autorelease];
    
    [alerView show];
    
    //移除广告
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UFK_SHOW_AD];
    [[[CCDirector sharedDirector].view viewWithTag:kTAG_Ad_VIEW]removeFromSuperview];
    
    // Your application should implement these two methods.

    [self recordTransaction:transaction];
     [self provideContent:transaction.payment.productIdentifier];

    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"failedTransaction------!!! error.code:%d",transaction.error.code);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        UIAlertView *alerView2 =  [[[UIAlertView alloc] initWithTitle:nil
                                                              message:@"Purchase Failed"
                                                             delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil]autorelease];
        
        [alerView2 show];
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"-------restoreTransaction");
    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
-(void)recordTransaction:(SKPaymentTransaction *)product{
    CCLOG(@"recordTransaction-----product:%@",product);
}

-(void)provideContent:(NSString *)product{
    CCLOG(@"provideContent--------product:%@",product);
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}



-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    CCLOG(@"-------paymentQueue----");
}

#pragma mark connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"%@",  [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    switch([(NSHTTPURLResponse *)response statusCode]) {
        case 200:
        case 206:
            break;
        case 304:
            break;
        case 400:
            break;
        case 404:
            break;
        case 416:
            break;
        case 403:
            break;
        case 401:
        case 500:
            break;
        default:
            break;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"test");
}    
-(void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    [super dealloc];
}
@end
