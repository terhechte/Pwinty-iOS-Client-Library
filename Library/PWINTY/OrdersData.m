//
//  OrdersData.m
//  PWINTY
//
//  Created by Chinara Kuzekeeva on 3/27/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "OrdersData.h"
#import "PwintyKeys.h"
#import "PhotosData.h"
#import "Utils.h"

@interface OrdersData() {
    NSDictionary *_shippingInfo;
    NSURL *_paymentURL;
}

- (void) setPaymentURL:(NSURL*)url;
- (void) setShippingInfo:(NSDictionary*)shippingInfo;

@end

@implementation OrdersData

@synthesize shippingInfo = _shippingInfo;
@synthesize paymentURL = _paymentURL;

+ (NSDictionary *)createDictionaryFromObject:(OrdersData *)oData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:oData.recipientName forKey:kRecipientName];
    if (oData.oID > 0)
        [dict setObject:@(oData.oID) forKey:kID];
    if (oData.address1 != nil)
        [dict setObject:oData.address1 forKey:kAddress1];
    if (oData.address2 != nil)
        [dict setObject:oData.address2 forKey:kAddress2];
    if (oData.addressTownOrCity != nil)
        [dict setObject:oData.addressTownOrCity forKey:kAddressTownOrCity];
    if (oData.stateOrCountry != nil)
        [dict setObject:oData.stateOrCountry forKey:kStateOrCountry];
    if (oData.postalOrZipCode != nil)
        [dict setObject:oData.postalOrZipCode forKey:kPostalOrZipCode];
    if (oData.country != nil)
        [dict setObject:oData.country forKey:kCountry];
    if (oData.destinationCountryCode != nil)
        [dict setObject:oData.destinationCountryCode forKey:kDestinationCountryCode];
    [dict setObject:@(oData.useTrackedShipping) forKey:kUseTrackedShipping];
    [dict setObject:oData.payment forKey:kPayment];
    [dict setObject:oData.qualityLevel forKey:kQualityLevel];
    if (oData.paymentURL)
        [dict setObject:[oData.paymentURL absoluteString] forKey:kPaymentURL];
    if (oData.shippingInfo)
        [dict setObject:[Utils nonNulledDict:oData.shippingInfo] forKey:kShippingInfo];
    return dict.copy;
}

+ (OrdersData *)createObjectFromDictionary:(NSDictionary *)dict
{
    dict = [Utils nonNulledDict:dict];
    id obj;
    OrdersData *oData;
    oData = [[OrdersData alloc] init];
    oData.oID = [[dict objectForKey:kID] intValue];
    oData.recipientName = [dict objectForKey:kRecipientName];
    oData.address1 = [dict objectForKey:kAddress1];
    oData.stateOrCountry = [dict objectForKey:kStateOrCountry];
    oData.postalOrZipCode = [dict objectForKey:kPostalOrZipCode];
    oData.country = [dict objectForKey:kCountry];
    oData.status = [dict objectForKey:kStatus];
    oData.photos = [dict objectForKey:kPhotos];
    obj = [dict objectForKey:kAddress2];
    if ([obj isKindOfClass:[NSNull class]]) oData.address2 = nil;
    else oData.address2 = obj;
    
    obj = [dict objectForKey:kAddressTownOrCity];
    if ([obj isKindOfClass:[NSNull class]]) oData.addressTownOrCity = nil;
    else oData.addressTownOrCity = obj;
    
    if ([oData.photos count] > 0)
    {
        oData.photos = [PhotosData createArrayOfObjectsFromArray:oData.photos];
    }
    oData.destinationCountryCode = [dict objectForKey:kDestinationCountryCode];
    
    obj = [dict objectForKey:kUseTrackedShipping];
    if ([obj isKindOfClass:[NSNull class]]) oData.useTrackedShipping = NO;
    else oData.useTrackedShipping = [(NSNumber*)obj boolValue];
    oData.payment = [dict objectForKey:kPayment];
    oData.qualityLevel = [dict objectForKey:kQualityLevel];
    
    obj = [dict objectForKey:kPaymentURL];
    if ([obj isKindOfClass:[NSNull class]]) [oData setPaymentURL:nil];
    else [oData setPaymentURL:[NSURL URLWithString:obj]];
    
    obj = [dict objectForKey:kShippingInfo];
    if ([obj isKindOfClass:[NSNull class]]) [oData setShippingInfo:nil];
    else [oData setShippingInfo:obj];
    
    return oData;
}

+ (NSArray *)createArrayOfObjectsFromArray:(NSArray *)array
{
    OrdersData *oData;
    NSMutableArray *arr;
    arr = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        oData = [OrdersData createObjectFromDictionary:dict];
        if (oData != nil)[arr addObject:oData];
    }
    return arr;
}

- (void) setShippingInfo:(NSDictionary *)shippingInfo {
    self->_shippingInfo = shippingInfo;
}

- (void) setPaymentURL:(NSURL *)url {
    self->_paymentURL = url;
}

@end
