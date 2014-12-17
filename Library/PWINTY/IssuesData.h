//
//  IssuesData.h
//  SocialCollage
//
//  Created by Benedikt Terhechte on 12/16/14.
//  Copyright (c) 2014 Benedikt Terhechte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IssuesData : NSObject

/**
 Id of the issue this object relates to.
 */
@property (assign, nonatomic) int issueId;

/**
 Id of the order this object relates to.
 */
@property (assign, nonatomic) int orderId;

/**
 the type of issue. 
 */
@property (retain) NSString *issue;

/**
  (optional) a textual description of the issue providing additional information where necessary
 */
@property (retain) NSString *issueDetail;

/**
  the required action.
 */
@property (retain) NSString *action;

/**
  the status of the issue
 one of:
 NotSpecified,
 Open,
 InProgress,
 ClosedNotResolved,
 ClosedResolved,
 Cancelled
 */
@property (retain) NSString *issueState;

+ (IssuesData *)createObjectFromDictionary:(NSDictionary *)dict;

+ (NSDictionary *)createDictionaryFromObject:(IssuesData *)pData;

@end
