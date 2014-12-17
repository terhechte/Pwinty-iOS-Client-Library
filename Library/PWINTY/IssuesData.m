//
//  IssuesData.m
//  SocialCollage
//
//  Created by Benedikt Terhechte on 12/16/14.
//  Copyright (c) 2014 Benedikt Terhechte. All rights reserved.
//

#import "IssuesData.h"
#import "PwintyKeys.h"
#import "Utils.h"

@implementation IssuesData

+ (IssuesData *)createObjectFromDictionary:(NSDictionary *)dict {
    IssuesData *d = [[IssuesData alloc] init];
    if ([dict objectForKey:kID])
        d.issueId = (int)[(NSNumber*)[dict objectForKey:kID] integerValue];
    if ([dict objectForKey:kOrderID])
        d.orderId = (int)[(NSNumber*)[dict objectForKey:kOrderID] integerValue];
    if ([dict objectForKey:kIssueIssue])
        d.issue = [dict objectForKey:kIssueIssue];
    if ([dict objectForKey:kIssueDetail])
        d.issueDetail = [dict objectForKey:kIssueDetail];
    if ([dict objectForKey:kIssueAction])
        d.action = [dict objectForKey:kIssueAction];
    if ([dict objectForKey:kIssueState])
        d.issueState = [dict objectForKey:kIssueState];
    
    return d;
}

+ (NSDictionary *)createDictionaryFromObject:(IssuesData *)pData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%d",  pData.orderId] forKey:kOrderID];
    [dict setObject:pData.issue forKey:kIssueIssue];
    [dict setObject:pData.action forKey:kIssueAction];
    if (pData.issueDetail)
        [dict setObject:pData.issueDetail forKey:kIssueDetail];
    if (pData.issueState)
        [dict setObject:pData.issueState forKey:kIssueState];
    return dict.copy;
}

@end
