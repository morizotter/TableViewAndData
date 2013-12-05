//
//  TWManager.m
//  TableViewAndData
//
//  Created by Morita Naoki on 2013/12/05.
//  Copyright (c) 2013年 molabo. All rights reserved.
//

#import "TWManager.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

static NSString *const API_ROOT = @"https://api.twitter.com/1.1/";
static NSString *const USER_TIMELINE = @"statuses/home_timeline.json";
static NSString *const ACCOUNT_IDENTIFIER_KEY = @"ACCOUNT_IDENTIFIER_KEY";

@implementation TWManager

static TWManager *sharedInstance = nil;
+ (TWManager *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TWManager alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _accountStore = [[ACAccountStore alloc]init];
    }
    return self;
}

- (NSString *)identifier
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:ACCOUNT_IDENTIFIER_KEY];
}

- (void)setIdentifier:(NSString *)identifier
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:identifier forKey:ACCOUNT_IDENTIFIER_KEY];
    [ud synchronize];
}

- (void)twAccountsWithSuccess:(TWSuccessBlock)successBlock failure:(TWFailureBlock)failureBlock
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        ACAccountType *twitterAccountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [_accountStore requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted)
                {
                    NSArray *twitterAccounts = [_accountStore accountsWithAccountType:twitterAccountType];
                    successBlock(twitterAccounts);
                }
                else {
                    failureBlock([ error localizedDescription]);
                }
            });
         }];
    }
}

- (void)timelineWithSuccess:(TWTimelineSuccessBlock)successBlock failure:(TWTimelineFailureBlock)failureBlock
{
    NSString *identifier = [self identifier];
    if (!identifier) {
        return;
    }
    ACAccount *account = [self.accountStore accountWithIdentifier:identifier];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_ROOT,USER_TIMELINE];
    NSURL *url = [NSURL URLWithString:urlString];
    SLRequest *request =
    [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:nil];
    [request setAccount:account];
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseData)
            {
                if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                    NSError *jsonError;
                    NSArray *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                    if (timelineData)
                    {
                        if (successBlock)
                        {
                            successBlock(timelineData);
                        }
                    }
                    else
                    {
                        if (failureBlock)
                        {
                            failureBlock([NSString stringWithFormat:@"JSON Error: %@", [jsonError localizedDescription]]);
                        }
                    }
                }
                else {
                    if (failureBlock)
                    {
                        failureBlock([NSString stringWithFormat:@"The response status code is %ld", (long)urlResponse.statusCode]);
                    }
                }
            }
        });
    }];
}

@end
