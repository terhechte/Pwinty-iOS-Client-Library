//
//  Loader.m
//  PWINTY
//
//  Created by Chinara Kuzekeeva on 3/27/12.
//  Copyright (c) 2012 Sibers. All rights reserved.
//

#import "Loader.h"

@implementation Loader
@synthesize loaderTag;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id<LoaderProtocol>)delegate
{
    self = [super init];
    if (self) {
        target = delegate;
        receivedData = [[NSMutableData alloc] init];
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    return self;
}

+ (Loader *)loadWithRequest:(NSMutableURLRequest *)request delegate:(id<LoaderProtocol>)delegate
{
    Loader *loader = [[Loader alloc] initWithRequest:request delegate:delegate];
    return loader;
}

#pragma mark - NSURLConnectionDelegates

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *errorDesc = [error localizedDescription];
    [receivedData setLength:0];
    NSLog(@"error: %@", error);
    if([target respondsToSelector:@selector(loadingDidFinishWithError:)])[target loadingDidFinishWithError:errorDesc];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    //[receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
    if([target respondsToSelector:@selector(loadingDidProceedWithStatus:)])[target loadingDidProceedWithStatus:totalBytesWritten];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if([target respondsToSelector:@selector(loadingDidFinishWithResult:andLoader:)])[target loadingDidFinishWithResult:receivedData andLoader:self];
    [receivedData setLength:0];
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection
{
    return YES;
}

@end
