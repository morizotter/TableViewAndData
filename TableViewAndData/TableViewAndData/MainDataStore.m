//
//  MainDataStore.m
//  TableViewAndData
//
//  Created by Morita Naoki on 2013/12/05.
//  Copyright (c) 2013年 molabo. All rights reserved.
//

#import "MainDataStore.h"

#import "TWManager.h"
#import "MainSectionData.h"
#import "MainRowData.h"

@implementation MainDataStore

- (void)updateWithSuccess:(MainDataStoreFetchSuccessBlock)successBlock failure:(MainDataStoreFetchFailureBlock)failureBlock
{
    [[TWManager sharedInstance] timelineWithSuccess:^(NSArray *timeline) {
        
        NSMutableArray *rowDataArray = @[].mutableCopy;
        for (int i=0; i<timeline.count; i++) {
            NSDictionary *tw = timeline[i];
            MainRowData *rowData = [[MainRowData alloc] init];
            rowData.name = tw[@"user"][@"name"];
            rowData.text = tw[@"text"];
            [rowDataArray addObject:rowData];
        }
        
        MainSectionData *sectionData = [[MainSectionData alloc] init];
        sectionData.title = @"Only one section Title";
        sectionData.rowDataArray = rowDataArray;
        
        self.sectionDataArray = @[sectionData].mutableCopy;
        
        if (successBlock) {
            successBlock(self.sectionDataArray.count);
        }
        
    } failure:^(NSString *message) {
        failureBlock(message);
    }];
}

@end
