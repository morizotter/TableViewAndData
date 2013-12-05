//
//  MainViewController.m
//  TableViewAndData
//
//  Created by Morita Naoki on 2013/12/05.
//  Copyright (c) 2013年 molabo. All rights reserved.
//

#import "MainViewController.h"

#import <Accounts/Accounts.h>
#import "TWManager.h"

#import "MainDataStore.h"

static NSString *const kSubtitleCellIdentifier = @"SubtitleCell";

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@end

@implementation MainViewController
{
    MainDataStore *_mainDataStore;
    UIRefreshControl *_refreshControl;
}

- (void)awakeFromNib
{
    self.title = @"Table&Data";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // prepare data store
    _mainDataStore = [[MainDataStore alloc] init];
    
    // prepare for refreshing
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(updateTableView) forControlEvents:UIControlEventValueChanged];
    [_contentTableView addSubview:_refreshControl];
    
    // check if twitter account is selected
    if ([[TWManager sharedInstance] identifier]) {
        self.navigationItem.leftBarButtonItem = nil;
        [self updateTableView];
    }
}

- (void)updateTableView
{
    [_mainDataStore fetchWithSuccess:^(NSUInteger count) {
        [self.contentTableView reloadData];
        [_refreshControl endRefreshing];
    } failure:^(NSString *message) {
        UIAlertView *aView = [[UIAlertView alloc] init];
        [aView setTitle:@"Failure"];
        [aView setMessage:message];
        [aView addButtonWithTitle:@"OK"];
        [aView show];
        [_refreshControl endRefreshing];
    }];
}

#pragma mark - table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _mainDataStore.sectionDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[_mainDataStore sectionDataArray][section] rowDataArray] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_mainDataStore.sectionDataArray[section] title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainRowData *rowData = [_mainDataStore.sectionDataArray[indexPath.section] rowDataArray][indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSubtitleCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = rowData.name;
    cell.detailTextLabel.text = rowData.text;
    
    return cell;
}

#pragma mark - table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainRowData *rowData = [_mainDataStore.sectionDataArray[indexPath.section] rowDataArray][indexPath.row];
    
    UIAlertView *aView = [[UIAlertView alloc] init];
    [aView setTitle:rowData.name];
    [aView setMessage:rowData.text];
    [aView addButtonWithTitle:@"OK"];
    [aView show];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - TW : Not important portion for this project
////////////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)twButtonTapped:(UIBarButtonItem *)sender
{
    [[TWManager sharedInstance] twAccountsWithSuccess:^(NSArray *accounts) {
        UIActionSheet *aSheet = [[UIActionSheet alloc] init];
        [aSheet setDelegate:self];
        [aSheet setTitle:@"Accounts"];
        for (ACAccount *account in accounts) {
            [aSheet addButtonWithTitle:account.username];
        }
        [aSheet addButtonWithTitle:@"Cancel"];
        [aSheet showInView:self.view];
        
    } failure:^(NSString *message) {
        NSLog(@"message: %@",message);
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    TWManager *manager = [TWManager sharedInstance];
    for (ACAccount *account in manager.accountStore.accounts) {
        if ([account.username isEqualToString:buttonTitle]) {
            [manager setIdentifier:account.identifier];
            UIAlertView *aView = [[UIAlertView alloc] init];
            [aView setTitle:@"Account set"];
            [aView setMessage:[NSString stringWithFormat:@"hi, %@.",account.username]];
            [aView addButtonWithTitle:@"OK"];
            [aView show];
            
            self.navigationItem.leftBarButtonItem = nil;
            [self updateTableView];
        }
    }
}

@end
