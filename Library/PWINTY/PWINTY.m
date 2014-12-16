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
    WebServices *_webservice;
}
@property (retain, nonatomic) NSString *merchantID;
@property (retain, nonatomic) NSString *APIKey;
@property (retain, nonatomic) NSString *HOST;
@end

@implementation PWINTY

- (id)initWithMerchantID:(NSString *)mID APIKey:(NSString *)key andDelegate:(id<WebServicesProtocol>)target
{
    self = [super init];
    if (self) {
        _webservice = [WebServices webserviceInstance];
        _webservice.merchantID = mID;
        _webservice.APIKey = key;
        _webservice.delegate = target;
   }
    
    return self;
}

- (void) setDelegate:(id<WebServicesProtocol>)aDelegate {
    _webservice.delegate = aDelegate;
}

- (void)useSandboxHost:(BOOL)isSandBox
{
    if (isSandBox) _webservice.HOST = kSandBoxHost;
    else _webservice.HOST = kLiveHost;
}

- (void)loadOrders
{
    [_webservice loadOrders];
}

- (void)loadOrderWithOrderID:(int)oID
{
    [_webservice loadOrderWithOrderID:oID];
}


- (void)createNewOrderWithParams:(OrdersData *)oData
{
    NSDictionary *dict = [OrdersData createDictionaryFromObject:oData];
    [_webservice createNewOrderWithParams:dict];
}

- (void)updateOrderWithParams:(OrdersData *)oData {
    NSDictionary *dict = [OrdersData createDictionaryFromObject:oData];
    // remove shipping info
    NSMutableDictionary *dx = dict.mutableCopy;
    [dx removeObjectForKey:@"shippingInfo"];
    dict = dx.copy;
    [_webservice updateOrder:oData.oID withParams:dict];
}

- (void )setOrder:(NSInteger)oid status:(NSString*)status {
    [_webservice setOrder:oid status:status];
}

- (void)getOrdersWithSubmissionStatusesByID:(int)oID
{
    [_webservice getOrdersWithSubmissionStatusesByID:oID];
}

- (void)addPhotoToOrderWithParams:(PhotosData *)params
{
    [_webservice addPhotoToOrderWithParams:params];
}

- (void)getPhotoInfoWithId:(int)pID
{
    [_webservice getPhotoInfoWithId:pID];
}

@end
