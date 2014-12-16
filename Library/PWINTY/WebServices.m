//
//  WebServices.m
//  PWINTY
//
//  Created by Chinara Kuzekeeva on 3/27/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "WebServices.h"
#import "Utils.h"
#import "SubmissionData.h"
#import "Loader.h"

@interface WebServices () <LoaderProtocol>{
    PhotosData *_currentUploadingPhotosData;
}
- (void)startRequest:(requestType)type;
@end

@implementation WebServices

#pragma mark - Singletone

+ (WebServices *)webserviceInstance
{
    WebServices * shareInstance = [[WebServices alloc] init];
    shareInstance.HOST = @"";
    shareInstance.merchantID = @"";
    shareInstance.APIKey = @"";
    return shareInstance;
}

#pragma mark - RequestBuilder

- (void)buildGETRequestWithType:(requestType)type URL:(NSURL *)url
{
    [self startRequest:type];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request addValue:_merchantID forHTTPHeaderField:@"X-Pwinty-MerchantId"];
    [request addValue:_APIKey forHTTPHeaderField:@"X-Pwinty-REST-API-Key"];
    Loader *ldr = [Loader loadWithRequest:request delegate:self];
    ldr.loaderTag = type;
}

- (void)buildPOSTRequestWithType:(requestType)type URL:(NSURL *)url body:(NSString *)body
{
    [self startRequest:type];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    
    
   NSData *bodyData  =  [[body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                               dataUsingEncoding:NSUTF8StringEncoding 
                               allowLossyConversion:YES];
    
	[request setHTTPMethod:@"POST"];
	
    //add header info
    [request addValue:_merchantID forHTTPHeaderField:@"X-Pwinty-MerchantId"];
    [request addValue:_APIKey forHTTPHeaderField:@"X-Pwinty-REST-API-Key"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //create the body of the post
    [request setHTTPBody:bodyData];
    
    Loader *ldr = [Loader loadWithRequest:request delegate:self];
    ldr.loaderTag = type;
}

- (void)buildPUTRequestWithType:(requestType)type URL:(NSURL *)url body:(NSString *)body
{
    [self startRequest:type];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];
    
    
   NSData *bodyData  =  [[body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
                               dataUsingEncoding:NSUTF8StringEncoding 
                               allowLossyConversion:YES];
    
	[request setHTTPMethod:@"PUT"];
	
    //add header info
    [request addValue:_merchantID forHTTPHeaderField:@"X-Pwinty-MerchantId"];
    [request addValue:_APIKey forHTTPHeaderField:@"X-Pwinty-REST-API-Key"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    //create the body of the post
    [request setHTTPBody:bodyData];
    
    Loader *ldr = [Loader loadWithRequest:request delegate:self];
    ldr.loaderTag = type;
}

- (void)builPOSTRequestFirPhotosUploadingWithType:(requestType)type URL:(NSURL *)url params:(PhotosData *)params
{
    [self startRequest:type];
    [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
    NSInputStream *inputStream;
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"-P-W-I-N-T-Y-I-P-H-O-N-E-A-P-P-";
    [request addValue:_merchantID forHTTPHeaderField:@"X-Pwinty-MerchantId"];
    [request addValue:_APIKey forHTTPHeaderField:@"X-Pwinty-REST-API-Key"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postbody = [NSMutableData data];
    
    NSString *filename = params.photoFileName;
    if (!filename || filename.length == 0) {
        NSInteger rnd = arc4random() % 2500;
        filename = [NSString stringWithFormat:@"random_file%li", rnd];
    }
    
    // file
    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@\"; filename=\"%@.jpg\"\r\n", kPhotoFile, filename] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:params.photoFile];
    [postbody appendData:[@"\r\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    // order id
    [Utils appendName:kOrderID value:[NSString stringWithFormat:@"%d", params.oID] boundary:boundary toPostBody:postbody];
    
    //type
    [Utils appendName:kPhotoType value:params.photoType boundary:boundary toPostBody:postbody];
    
    //copies
    [Utils appendName:kPhotoCopies value:[NSString stringWithFormat:@"%d", params.photoCopies] boundary:boundary toPostBody:postbody];
    
    //sizing
    [Utils appendName:kPhotoSizing value:params.photoSizing boundary:boundary toPostBody:postbody];
    
    //userpice
    if (params.priceToUser > 0)
        [Utils appendName:kPhotoPriceToUser value:[NSString stringWithFormat:@"%li", params.priceToUser] boundary:boundary toPostBody:postbody];
    
    //md5hash
    if (params.md5Hash)
        [Utils appendName:kPhotoMD5Hash value:params.md5Hash boundary:boundary toPostBody:postbody];
    
   //close form
    [postbody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //NSString *str = [[NSString alloc] initWithData:postbody.copy encoding:NSASCIIStringEncoding];
    //NSLog(@"postbody --- %@", str);
    
    inputStream = [NSInputStream inputStreamWithData:postbody.copy];
    [request setHTTPBodyStream:inputStream];
    
    Loader *ldr = [Loader loadWithRequest:request delegate:self];
    ldr.loaderTag = type;
}

#pragma mark - API

- (void)loadOrders //get
{
    _currentUploadingPhotosData = nil;
    NSString * path = [_HOST stringByAppendingPathComponent:kOrdersHostTail];
    NSURL * url = [NSURL URLWithString:path];
    [self buildGETRequestWithType:kTypeOrders URL:url];
    
}

- (void)loadOrderWithOrderID:(int)oID; //get
{
    _currentUploadingPhotosData = nil;
    NSString *idStr = [NSString stringWithFormat:@"%d", oID];
    NSString * path = [_HOST stringByAppendingPathComponent:kOrdersHostTail];
    NSURL * url = [Utils buildGETRequestWithPath:path andParams:[NSDictionary dictionaryWithObject:idStr forKey:kID]];
    [self buildGETRequestWithType:kTypeOrders URL:url];

}

- (void)createNewOrderWithParams:(NSDictionary *)params //post
{
    _currentUploadingPhotosData = nil;
    NSString *jsonStr;
    NSString * path = [_HOST stringByAppendingPathComponent:kOrdersHostTail];
    NSURL *url = [NSURL URLWithString:path];
    jsonStr = [Utils buildRequestParamsString:params];
    [self buildPOSTRequestWithType:kTypeCreateOrder URL:url body:jsonStr];
}

- (void)updateOrder:(int)oid withParams:(NSDictionary *)params //put
{
    _currentUploadingPhotosData = nil;
    NSString *jsonStr;
    NSString *idStr = [NSString stringWithFormat:@"%@/%i", kOrdersHostTail, oid];
    NSString *path = [_HOST stringByAppendingPathComponent:idStr];
    NSURL *url = [NSURL URLWithString:path];
    jsonStr = [Utils buildRequestParamsString:params];
    [self buildPUTRequestWithType:kTypeUpdateOrder URL:url body:jsonStr];
}

- (void)setOrder:(NSInteger)order status:(NSString*)status
{
    _currentUploadingPhotosData = nil;
    NSString *jsonStr = [Utils buildRequestParamsString:@{@"status": status}];
    NSURL *url = [Utils buildURLWithHOST:_HOST andTail:
                  [NSString stringWithFormat:kOrdersStatusHostTail, order]];
    [self buildPOSTRequestWithType:kTypeOrderStatus URL:url body:jsonStr];

}

- (void)getOrdersWithSubmissionStatusesByID:(int)oID
{
    _currentUploadingPhotosData = nil;
    NSString *path = [_HOST stringByAppendingPathComponent:[NSString stringWithFormat:kOrderSubmissionHostTail, oID]];
    //NSURL * url = [Utils buildGETRequestWithPath:path andParams:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", oID] forKey:kID]];
    [self buildGETRequestWithType:kTypeOredrSubmissionStatus URL:[NSURL URLWithString:path]];
}

- (void)getPhotoInfoWithId:(int)pID // photo id
{
    _currentUploadingPhotosData = nil;
    NSString *idStr = [NSString stringWithFormat:@"%d", pID];
    NSString * path = [_HOST stringByAppendingPathComponent:kPhotosHostTail];
    NSURL * url = [Utils buildGETRequestWithPath:path andParams:[NSDictionary dictionaryWithObject:idStr forKey:kID]];
    [self buildGETRequestWithType:kTypePhotos URL:url];
}

- (void)addPhotoToOrderWithParams:(PhotosData *)params
{
    NSString *photoAddTail = [NSString stringWithFormat:@"%@/%i/%@", kOrdersHostTail, params.oID, kPhotosHostTail];
    NSURL *url = [Utils buildURLWithHOST:_HOST andTail:photoAddTail];
    if (params.photoPath != nil)
    {
        NSDictionary *dict = [PhotosData createDictionaryFromObject:params];
        NSString *jsonStr = [Utils buildRequestParamsString:dict];
        _currentUploadingPhotosData = params;
        if (jsonStr == nil) return;
        else [self buildPOSTRequestWithType:kTypeCreatePhoto URL:url body:jsonStr];
    }
    else if (params.photoFile != nil)
    {
        _currentUploadingPhotosData = params;
        [self builPOSTRequestFirPhotosUploadingWithType:kTypeCreatePhoto URL:url params:params];
    }
}

#pragma mark - LoaderDelegates
- (void)startRequest:(requestType)type
{
    if ([_delegate respondsToSelector:@selector(startRequestWithType:)])
    {
        [_delegate startRequestWithType:type];
    }
}

- (void)loadingDidFinishWithResult:(id)result andLoader:(id)loader
{
    //_currentUploadingPhotosData = nil;
    if (_delegate == nil)return;
    
    Loader *instance = (Loader *)loader;
    NSArray *resultArray = nil;
    NSError *error = nil;
    NSString *errorStr = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:result options:0 error:&error];
    if (jsonObj == nil) return;
    errorStr = [Utils getErrorTextFromObject:jsonObj];
    if (errorStr == nil && error == nil)
    {
        switch (instance.loaderTag) {
            case kTypeOrders:
            {
                if ([jsonObj isKindOfClass:[NSArray class]])
                {
                    resultArray = (NSArray *)jsonObj;
                }
                else if ([jsonObj isKindOfClass:[NSDictionary class]])
                {
                    resultArray = [NSArray arrayWithObject:jsonObj];
                }
                resultArray = [OrdersData createArrayOfObjectsFromArray:resultArray];
                if ([_delegate respondsToSelector:@selector(ordersLoadedWithResult:)])
                {
                    [_delegate ordersLoadedWithResult:resultArray];
                }
            }
                break;
              case kTypeCreateOrder:
            {
                OrdersData *oData = [OrdersData createObjectFromDictionary:jsonObj];
                if ([_delegate respondsToSelector:@selector(orderCreatedWithResult:)])
                {
                    [_delegate orderCreatedWithResult:oData];
                }
            }
                break;
              case kTypeUpdateOrder:
            {
                OrdersData *oData = [OrdersData createObjectFromDictionary:jsonObj];
                if ([_delegate respondsToSelector:@selector(orderUpdatedWithResult:)])
                {
                    [_delegate orderUpdatedWithResult:oData];
                }
            }
                break;
                case kTypeOrderStatus:
            {
                if ([_delegate respondsToSelector:@selector(orderStatusWithResult:)])
                {
                    [_delegate orderStatusWithResult:jsonObj];
                }

            }
                break;
                case kTypeOredrSubmissionStatus:
            {
                SubmissionData *sData;
                if ([jsonObj isKindOfClass:[NSDictionary class]])
                {
                    sData = [SubmissionData createObjectFromDictionary:jsonObj];
                    if ([_delegate respondsToSelector:@selector(orderSubmissionStatusWithResult:)])
                    {
                        [_delegate orderSubmissionStatusWithResult:sData];
                    }
                }
            }
                break;
                case kTypePhotos:
            {
                PhotosData *pData = [PhotosData createObjectFormDictionary:jsonObj];
                if ([_delegate respondsToSelector:@selector(photoInfoLoadedWithResult:)])
                {
                    [_delegate photoInfoLoadedWithResult:pData];
                }

            }
                break;
                case kTypeCreatePhoto:
            {
                PhotosData *pData = [PhotosData createObjectFormDictionary:jsonObj];
                if ([_delegate respondsToSelector:@selector(photoUploadedWithResult:)])
                {
                    [_delegate photoUploadedWithResult:pData];
                }
            }
                break;
            default:
                break;
        }
    }
    else
    {
        NSString *er = errorStr;
        if (!er && error)er = error.localizedDescription;
        
        if ([_delegate respondsToSelector:@selector(connectionDidFailWithError:)])
        {
            [_delegate connectionDidFailWithError:errorStr];
        }
    }
}

- (void)loadingDidProceedWithStatus:(NSUInteger)status {
    if (self.delegate && _currentUploadingPhotosData && _currentUploadingPhotosData.photoFile) {
        // calculate the percentage done
        double totalSize = _currentUploadingPhotosData.photoFile.length;
        double currentSize = status;
        [self.delegate photoUploadState:currentSize/totalSize
                               forPhoto:_currentUploadingPhotosData];
    }
}

- (void)loadingDidFinishWithError:(NSString *)error
{
    _currentUploadingPhotosData = nil;
    if (_delegate == nil)return;
    if ([_delegate respondsToSelector:@selector(connectionDidFailWithError:)])
    {
        [_delegate connectionDidFailWithError:error];
    }
}

@end
