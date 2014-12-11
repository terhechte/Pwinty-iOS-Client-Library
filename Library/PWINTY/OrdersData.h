//
//  OrdersData.h
//  PWINTY
//
//  Created by Chinara Kuzekeeva on 3/27/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//


/**
 Object representing specified order.
 */

@interface OrdersData : NSObject
/**
 Unique integer identifying the order
 */
@property (assign, nonatomic) int oID;
/**
 Who the order will be addressed to
 */
@property (retain, nonatomic) NSString *recipientName;
/**
 First line of recipient address
 */
@property (retain, nonatomic) NSString *address1;
/**
 Second line of recipient address (OPTIONAL)
 */
@property (retain, nonatomic) NSString *address2;
/**
 Town/City of recipient address
 */
@property (retain, nonatomic) NSString *addressTownOrCity;
/**
 State (US) or County (UK) of recipient address
 */
@property (retain, nonatomic) NSString *stateOrCountry;
/**
 Postal/Zipcode of recipient address
 */
@property (retain, nonatomic) NSString *postalOrZipCode;
/**
 CountryCode Country code of the country where the order should be printed
 */
@property (retain, nonatomic) NSString *country;
/**
 Status of order. 
 - Can be:
     1) kOrderStatusNotYetSubmitted;
     2) kOrderStatusSubmitted;
     3) kOrderStatusComplete;
     4) kOrderStatusCancelled;
 */
@property (retain, nonatomic) NSString *status;
/**
 An array of PhotosData objects representing the photos in the order. 
 */
@property (retain, nonatomic) NSArray *photos;
/**
 destinationCountryCode Country code of the country where the order will be shipped optional
 */
@property (retain, nonatomic) NSString *destinationCountryCode;
/**
 useTrackedShippingoptional whether to upgrade to a tracked shipping service when available.
 optional
 */
@property (assign, nonatomic) BOOL useTrackedShipping;
/**
 payment Payment option for order, 
 - Can be: 
     1) InvoiceMe 
     2) InvoiceRecipient
 */
@property (retain, nonatomic) NSString* payment;
/**
 qualityLevel Quality level for order
 - Can be:
    1) Pro
    2) Standard
 */
@property (retain, nonatomic) NSString* qualityLevel;

/**
 shippingInfo: The shipping information for the product, read only
 shippingInfo =     {
 isTracked = 0;
 price = 299;
 trackingNumber = "<null>";
 trackingUrl = "<null>";
 };

 */
@property (readonly) NSDictionary *shippingInfo;

/**
 paymentUrl: For InvoiceRecipient, the PaymentURL to show to the recipient
 */
@property (readonly) NSURL *paymentURL;

/**
 Return NSDictionary with spesified keys.
 */
+ (NSDictionary *)createDictionaryFromObject:(OrdersData *)oData;

/**
 Return OrdersData object.
 */
+ (OrdersData *)createObjectFromDictionary:(NSDictionary *)dict;

/**
 Return an array of OrdersData objects.
 */
+ (NSArray *)createArrayOfObjectsFromArray:(NSArray *)array;
@end
