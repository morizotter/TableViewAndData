//
//  MainDataStore.h
//  TableViewAndData
//
//  Created by Morita Naoki on 2013/12/05.
//  Copyright (c) 2013年 molabo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MainSectionData.h"
#import "MainRowData.h"

typedef void(^MainDataStoreFetchSuccessBlock)(NSUInteger count);
typedef void(^MainDataStoreFetchFailureBlock)(NSString *message);

@interface MainDataStore : NSObject
@property (strong, nonatomic) NSMutableArray *sectionDataArray;

- (void)fetchWithSuccess:(MainDataStoreFetchSuccessBlock)successBlock
                 failure:(MainDataStoreFetchFailureBlock)failureBlock;
@end
