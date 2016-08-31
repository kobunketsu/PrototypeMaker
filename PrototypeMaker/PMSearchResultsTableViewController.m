//
//  SearchResultsTableViewController.m
//  Sample-UISearchController
//
//  Created by James Dempsey on 9/20/14.
//  Copyright (c) 2014 Tapas Software. All rights reserved.
//

#import "PMSearchResultsTableViewController.h"
//#import "DetailViewController.h"
#import "PMDataModel.h"
#import "PMDataViewController.h"
#import "PMBasicInfoViewController.h"
@implementation PMSearchResultsTableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResultIds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell" forIndexPath:indexPath];

    NSString *key = self.searchResultIds[indexPath.row];
    switch (self.searchMode) {
        case PMSearchIdea: {
            cell.textLabel.text = ((PMIdea *)[PMIdea ideaOfId:key]).title;
            break;
        }
        case PMSearchProto: {
            cell.textLabel.text = ((PMPrototype *)[[PMDataModel current].protos valueForKey:key]).title;
            break;
        }
        case PMSearchTag: {
            cell.textLabel.text = ((PMTag *)[[PMDataModel current].tags valueForKey:key]).title;
            break;
        }
        default: {
            break;
        }
    }

    return cell;

}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    Product *product = [self.searchResults objectAtIndex:indexPath.row];
//    DetailViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"DetailViewController"];
//    self.presentingViewController.navigationItem.title = @"Search";
//    vc.product = product;
//    [self.presentingViewController.navigationController pushViewController:vc animated:YES];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.searchMode) {
        case PMSearchIdea: {
            PMIdea *idea = [PMIdea ideaOfId:self.searchResultIds[indexPath.row]];
            if (self.delegate) {
                [self.delegate willAddSearchResults:idea];
            }
            break;
        }
        case PMSearchProto: {
            PMPrototype *proto = [[PMDataModel current].protos valueForKey:self.searchResultIds[indexPath.row]];
            
            if (self.delegate) {
                [self.delegate willAddSearchResults:proto];
            }
            break;
        }
        case PMSearchTag: {
            PMTag *tag = [[PMDataModel current].tags valueForKey:self.searchResultIds[indexPath.row]];
            
            if (self.delegate) {
                [self.delegate willAddSearchResults:tag];
            }
            break;
        }
        default: {
            break;
        }
    }
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
