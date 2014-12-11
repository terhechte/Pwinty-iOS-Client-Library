//
//  Utils.m
//  PWINTY
//
//  Created by Chinara Kuzekeeva on 3/27/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSURL *)buildURLWithHOST:(NSString *)host andTail:(NSString *)tail
{
    NSString * path = [host stringByAppendingPathComponent:tail];
    NSURL *url = [NSURL URLWithString:path];
    return url;
}

+ (NSString *)buildRequestParamsString:(NSDictionary *)params
{
    NSArray *keys = [params allKeys];
    NSMutableString *paramsStr = [NSMutableString string];
    NSString *val;
    NSString *key;
    
    for (int i = 0; i < [keys count]; i++)
    {
        key = [keys objectAtIndex:i];    
        val = [params objectForKey:key];
        if ([val isKindOfClass:[NSNumber class]])
            val = [NSString stringWithFormat:@"%@", val];
        [paramsStr appendFormat:@"%@=%@", key, val];
        if (i != [keys count]-1)
        {
            [paramsStr appendString:@"&"];
        }
    }
    return paramsStr;
}

+ (NSURL *)buildGETRequestWithPath:(NSString *)path andParams:(NSDictionary *)params
{
    NSString *paramsStr = [self buildRequestParamsString:params];
    NSString *buildedPath;
    buildedPath = [NSString stringWithFormat:@"%@?%@", path, paramsStr];
    return [NSURL URLWithString:buildedPath];
}

+ (NSArray *)dictionaryToArray:(NSDictionary *)params
{
    NSArray *keys = [params allKeys];
    NSMutableArray *arr = [NSMutableArray array];
    NSString *val;
    NSString *key;
    
    for (int i = 0; i < [keys count]; i++)
    {
        key = [keys objectAtIndex:i];    
        val = [params objectForKey:key];
        [arr addObject:val];
    }
    return [NSArray arrayWithArray:arr];
}

+ (NSString *)getErrorTextFromObject:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)object;
        return [dict objectForKey:@"error"];
    }
    else return nil;
}

+ (NSDictionary*) nonNulledDict:(NSDictionary*)dictionary
{
    // remove all nulls
    NSMutableDictionary *dx = dictionary.mutableCopy;
    for (NSString *key in dictionary.allKeys) {
        if ((NSNull*)[dictionary objectForKey:key] == [NSNull null]) {
            [dx removeObjectForKey:key];
        }
    }
    return dx.copy;
}

+ (BOOL)isFieldEmpty:(NSDictionary *)dict exceptions:(NSArray *)ex
{
    id obj;
    NSMutableArray *keys = [NSMutableArray arrayWithArray:[dict allKeys]];
    if (ex != nil)
    {
        [keys removeObjectsInArray:ex]; //remove optional fiels from validation
    }
    
    for (NSString *key in keys)
    {
        obj = [dict objectForKey:key];
        if ([obj isKindOfClass:[NSNull class]])
        {
            return YES; 
        }
    }
    return NO;
}

+ (void) appendName:(NSString*)name value:(NSString*)value boundary:(NSString*)boundary toPostBody:(NSMutableData*)postbody {
    [postbody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", name] dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[value dataUsingEncoding:NSUTF8StringEncoding]];
    [postbody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
