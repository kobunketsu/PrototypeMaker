//
//  SearchResultsTableViewController.h
//  Sample-UISearchController
//
//  Created by James Dempsey on 9/20/14.
//  Copyright (c) 2014 Tapas Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSearchTableViewController.h"
@interface PMSearchResultsTableViewController : UITableViewController
@property (assign, nonatomic) id delegate;
@property (nonatomic, strong) NSMutableArray *searchResultIds; // Filtered search results
@property (assign, nonatomic) PMSearchMode searchMode;
@end

@protocol PMSearchResultsTableViewControllerDelegate

- (void)willAddSearchResults:(PMBaseInfo *)baseInfo;

@end
