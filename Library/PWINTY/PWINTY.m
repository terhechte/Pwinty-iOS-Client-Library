//
//  PWINTY.m
//  PWINTY
//
//  Created by Chinara Kuzekeeva on 3/27/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PWINTY.h"
#import "WebServices.h"

@interface PWINTY () {
@private

}
@property (retain, nonatomic) NSString *merchantID;
@property (retain, nonatomic) NSString *APIKey;
@property (retain, nonatomic) NSString *HOST;
@end

@implementation PWINTY
@synthesize merchantID = _merchantID;
@synthesize APIKey = _APIKey;
@synthesize HOST = _HOST;
@synthesize delegate = _delegate;

- (id)initWithMerchantID:(NSString *)mID APIKey:(NSString *)key andDelegate:(id<WebServicesProtocol>)target
{
    self = [super init];
    if (self) {
        WebServices *ws = [WebServices currentInstance];
        ws.merchantID = mID;
        ws.APIKey = key;
        ws.delegate = target;
   }
    
    return self;
}

- (void)useSandboxHost:(BOOL)isSandBox
{
    WebServices *ws = [WebServices currentInstance];
    if (isSandBox) ws.HOST = kSandBoxHost;
    else ws.HOST = kLiveHost;
}

- (void)loadOrders
{
    [[WebServices currentInstance] loadOrders];
}

- (void)loadOrderWithOrderID:(int)oID
{
    [[WebServices currentInstance] loadOrderWithOrderID:oID];
}


- (void)createNewOrderWithParams:(OrdersData *)oData
{
    NSDictionary *dict = [OrdersData createDictionaryFromObject:oData];
    [[WebServices currentInstance] createNewOrderWithParams:dict];
}

- (void)setOrderStatusWithParams:(NSDictionary *)params
{
    [[WebServices currentInstance] setOrderStatusWithParams:params];
}

- (void)getOrdersWithSubmissionStatusesByID:(int)oID
{
    [[WebServices currentInstance] getOrdersWithSubmissionStatusesByID:oID];
}

- (void)addPhotoToOrderWithParams:(PhotosData *)params
{
    [[WebServices currentInstance] addPhotoToOrderWithParams:params];
}

- (void)getPhotoInfoWithId:(int)pID
{
    [[WebServices currentInstance] getPhotoInfoWithId:pID];
}

- (void)dealloc
{
    [super dealloc];
}

@end
