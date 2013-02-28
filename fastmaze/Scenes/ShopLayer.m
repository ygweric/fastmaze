//
//  ShopLayer.m
//  fastmaze
//
//  Created by Eric on 13-2-27.
//
//

#import "ShopLayer.h"

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
            [self setBg:@"main_bg.png"];
        }

        CCMenu* menuRemoveAd= [SpriteUtil createMenuWithImg:@"mode_endless.png" pressedColor:ccYELLOW target:self selector:@selector(removeAd)];
        [self addChild:menuRemoveAd];
        menuRemoveAd.position=ccp(winSize.width/2,winSize.height/2);
        //----监听购买结果
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}
-(void)removeAd{
    iapId=IAP_REMOVE_AD;
    if ([SKPaymentQueue canMakePayments]) {
        //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        [self RequestProductData];
        NSLog(@"---允许程序内付费购买");
    }
    else
    {
        NSLog(@"--不允许程序内付费购买");
        UIAlertView *alerView =  [[[UIAlertView alloc] initWithTitle:nil message:@"You can‘t purchase in app store" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil] autorelease];
        [alerView show];
        
    }
}
-(void)RequestProductData
{
    CCLOG(@"---------请求对应的产品信息------------");

    NSSet *nsset = [NSSet setWithObject:iapId];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=self;
    [request start];
}
//<SKProductsRequestDelegate> 请求协议
//收到的产品信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *myProduct = response.products;
    NSLog(@"产品Product ID:%@",response.invalidProductIdentifiers);
    NSLog(@"产品付费数量: %d", [myProduct count]);
    // populate UI
    SKProduct* productToBuy=nil;
    for(SKProduct *product in myProduct){
        NSLog(@"product info");
        NSLog(@"SKProduct 描述信息%@", [product description]);
        NSLog(@"产品标题 %@" , product.localizedTitle);
        NSLog(@"产品描述信息: %@" , product.localizedDescription);
        NSLog(@"价格: %@" , product.price);
        NSLog(@"Product id: %@" , product.productIdentifier);
        if ([product.productIdentifier isEqualToString:iapId]) {
            productToBuy=product;
        }
    }
    SKPayment *payment = [SKPayment paymentWithProduct:productToBuy];
     CCLOG(@"---------发送购买请求------------");
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [request autorelease];
    
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
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
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
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    CCLOG(@"-----paymentQueue--------transactions:%@",transactions);
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                [self completeTransaction:transaction];
                CCLOG(@"Purchase Success --------");
                UIAlertView *alerView =  [[[UIAlertView alloc] initWithTitle:@"Alert"
                                                                    message:@"Purchase Succesfully"
                                                                   delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil]autorelease];
                
                [alerView show];

                //移除广告
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:UFK_SHOW_AD];
                [[[CCDirector sharedDirector].view viewWithTag:kTAG_Ad_VIEW]removeFromSuperview];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                CCLOG(@"Purchase Failed --------");
                UIAlertView *alerView2 =  [[[UIAlertView alloc] initWithTitle:nil
                                                                     message:@"Purchase Failed"
                                                                    delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil]autorelease];
                
                [alerView2 show];
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
    // Your application should implement these two methods.
    NSString *product = transaction.payment.productIdentifier;
    if ([product length] > 0) {
        
        NSArray *tt = [product componentsSeparatedByString:@"."];
        NSString *bookid = [tt lastObject];
        if ([bookid length] > 0) {
            [self recordTransaction:bookid];
            [self provideContent:bookid];
        }
    }
    
    // Remove the transaction from the payment queue.
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    CCLOG(@"recordTransaction-----product:%@",product);
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    CCLOG(@"provideContent--------product:%@",product);
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"failedTransaction------!!! error.code:%d",transaction.error.code);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}
-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@"restoreTransaction-------");
    
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
