//
//  PhotosData.m
//  PWINTY
//
//  Created by Chinara Kuzekeeva on 3/29/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "PhotosData.h"
#import "PwintyKeys.h"
#import "Utils.h"

@interface PhotosData() {
    NSString *_errorMessage;
}
- (void) setErrorMessage:(NSString*)aErrorMessage;
@end

@implementation PhotosData

+ (NSDictionary *)createDictionaryFromObject:(PhotosData *)pData
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",  pData.oID] forKey:kOrderID];
    [dict setObject:[NSString stringWithFormat:@"%d", pData.photoID] forKey:kID];
    
    [dict setObject:[NSString stringWithFormat:@"%d", pData.photoCopies] forKey:kPhotoCopies];
    [dict setObject:pData.photoType forKey:kPhotoType];
    if (pData.photoPath)
        [dict setObject:pData.photoPath forKey:kPhotoPath];
    [dict setObject:pData.photoStatus forKey:kStatus];
    [dict setObject:pData.photoSizing forKey:kPhotoSizing];
    if (pData.photoFile)
        [dict setObject:pData.photoFile forKey:kPhotoFile];
    if (pData.photoFileName)
        [dict setObject:pData.photoFileName forKey:kphotoFileName];
    if (pData.md5Hash)
        [dict setObject:pData.md5Hash forKey:kPhotoMD5Hash];
    if (pData.priceToUser > 0)
        [dict setObject:@(pData.priceToUser) forKey:kPhotoPriceToUser];
    if (pData.errorMessage) {
        [dict setObject:pData.errorMessage forKey:kPhotoErrorMessage];
    }
    return dict;

}
+ (PhotosData *)createObjectFormDictionary:(NSDictionary *)dict
{
    dict = [Utils nonNulledDict:dict];
    PhotosData *pData = [[PhotosData alloc] init];
    pData.oID = [[dict objectForKey:kOrderID] intValue];
    pData.photoID = [[dict objectForKey:kID] intValue];
    pData.photoCopies = [[dict objectForKey:kPhotoCopies] intValue];
    pData.photoType = [dict objectForKey:kPhotoType];
    pData.photoPath = [dict objectForKey:kPhotoPath]; //optional
    pData.photoStatus = [dict objectForKey:kStatus];
    pData.photoSizing = [dict objectForKey:kPhotoSizing];
    pData.photoFile = [dict objectForKey:kPhotoFile]; //optional
    pData.photoFileName = [dict objectForKey:kphotoFileName]; //need only if photo file field is not empty
    pData.md5Hash = [dict objectForKey:kPhotoMD5Hash];
    pData.priceToUser = [[dict objectForKey:kPhotoPriceToUser] integerValue];
    if ([dict objectForKey:kPhotoErrorMessage])
        [pData setErrorMessage:[dict objectForKey:kPhotoErrorMessage]];
    return pData;
}

+ (NSArray *)createArrayOfObjectsFromArray:(NSArray *)array
{
    PhotosData *pData;
    NSMutableArray *arr;
    arr = [NSMutableArray array];
    for (NSDictionary * dict in array) {
        pData = [PhotosData createObjectFormDictionary:dict];
        if (pData != nil)[arr addObject:pData];
    }
    return arr;
}

- (void) setErrorMessage:(NSString*)aErrorMessage {
    self->_errorMessage = aErrorMessage;
}

- (NSString*) errorMessage {
    if (_errorMessage &&
        [_errorMessage isKindOfClass:[NSString class]] &&
        [_errorMessage length] > 0) {
        return _errorMessage;
    }
    return nil;
}

@end
