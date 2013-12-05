//
//  TWManager.h
//  TableViewAndData
//
//  Created by Morita Naoki on 2013/12/05.
//  Copyright (c) 2013年 molabo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Accounts/Accounts.h>

typedef void(^TWSuccessBlock)(NSArray *accounts);
typedef void(^TWFailureBlock)(NSString *message);

typedef void(^TWTimelineSuccessBlock)(NSArray *timeline);
typedef void(^TWTimelineFailureBlock)(NSString *message);

@interface TWManager : NSObject

@property (strong, nonatomic) ACAccountStore *accountStore;
+ (TWManager *)sharedInstance;
- (void)twAccountsWithSuccess:(TWSuccessBlock)successBlock failure:(TWFailureBlock)failureBlock;
- (void)timelineWithSuccess:(TWTimelineSuccessBlock)successBlock failure:(TWTimelineFailureBlock)failureBlock;
- (void)setIdentifier:(NSString *)identifier;
- (NSString *)identifier;

@end
