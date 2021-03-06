//
//  FLEXNetworkTransaction.h
//  Flipboard
//
//  Created by Ryan Olson on 2/8/15.
//  Copyright (c) 2020 FLEX Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

typedef NS_ENUM(NSInteger, FLEXNetworkTransactionState) {
    FLEXNetworkTransactionStateUnstarted,
    FLEXNetworkTransactionStateAwaitingResponse,
    FLEXNetworkTransactionStateReceivingData,
    FLEXNetworkTransactionStateFinished,
    FLEXNetworkTransactionStateFailed
};

typedef NS_ENUM(NSUInteger, FLEXWebsocketMessageDirection) {
    FLEXWebsocketIncoming = 1,
    FLEXWebsocketOutgoing,
};

@interface FLEXNetworkTransaction : NSObject

+ (instancetype)withRequest:(NSURLRequest *)request startTime:(NSDate *)startTime;

@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly) NSDate *startTime;

@property (nonatomic) NSError *error;
/// Subclasses can override to provide error state based on response data as well
@property (nonatomic, readonly) BOOL displayAsError;

@property (nonatomic) FLEXNetworkTransactionState transactionState;
@property (nonatomic) int64_t receivedDataLength;
/// A small thumbnail to preview the type of/the response
@property (nonatomic) UIImage *thumbnail;

+ (NSString *)readableStringFromTransactionState:(FLEXNetworkTransactionState)state;

/// Generated by this class using the URL provided by subclasses
@property (nonatomic, readonly) NSString *primaryDescription;
@property (nonatomic, readonly) NSString *secondaryDescription;
@property (nonatomic, readonly) NSString *tertiaryDescription;

/// Subclasses should implement for when the transaction is complete
@property (nonatomic, readonly) NSArray<NSString *> *details;

@end


@interface FLEXHTTPTransaction : FLEXNetworkTransaction

+ (instancetype)request:(NSURLRequest *)request identifier:(NSString *)requestID;

@property (nonatomic, readonly) NSString *requestID;
@property (nonatomic) NSURLResponse *response;
@property (nonatomic, copy) NSString *requestMechanism;

@property (nonatomic) NSTimeInterval latency;
@property (nonatomic) NSTimeInterval duration;

/// Populated lazily. Handles both normal HTTPBody data and HTTPBodyStreams.
@property (nonatomic, readonly) NSData *cachedRequestBody;

@end


@interface FLEXWebsocketTransaction : FLEXNetworkTransaction

+ (instancetype)withMessage:(NSURLSessionWebSocketMessage *)message
                       task:(NSURLSessionWebSocketTask *)task
                  direction:(FLEXWebsocketMessageDirection)direction API_AVAILABLE(ios(13.0));

+ (instancetype)withMessage:(NSURLSessionWebSocketMessage *)message
                       task:(NSURLSessionWebSocketTask *)task
                  direction:(FLEXWebsocketMessageDirection)direction
                  startTime:(NSDate *)started API_AVAILABLE(ios(13.0));

//@property (nonatomic, readonly) NSURLSessionWebSocketTask *task;
@property (nonatomic, readonly) NSURLSessionWebSocketMessage *message API_AVAILABLE(ios(13.0));
@property (nonatomic, readonly) FLEXWebsocketMessageDirection direction API_AVAILABLE(ios(13.0));

@property (nonatomic, readonly) int64_t dataLength API_AVAILABLE(ios(13.0));

@end
