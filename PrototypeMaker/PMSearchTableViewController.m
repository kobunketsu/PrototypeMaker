//
//  PMSearchTableViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/16/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMSearchTableViewController.h"
#import "PMDataModel.h"
#import "PMSearchResultsTableViewController.h"
#import "PMDataViewController.h"
#import "PMBasicInfoViewController.h"
#import "PMIdeaViewController.h"
#import "PMPrototypeViewController.h"
#import "PMTagViewController.h"
#import "PMSwipeTableCell.h"
@interface PMSearchTableViewController ()
<UISearchResultsUpdating,
UISearchBarDelegate,
PMSearchResultsTableViewControllerDelegate
>
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchSourceKeys;
@property (nonatomic, strong) NSMutableArray *searchResultKeys; // Filtered search results
@end

@implementation PMSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // The table view controller is in a nav controller, and so the containing nav controller is the 'search results controller'
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"TableSearchResultsNavController"];
    PMSearchResultsTableViewController *vc = (PMSearchResultsTableViewController *)searchResultsController.viewControllers.firstObject;
    vc.delegate = self;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.searchController.searchBar.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    for (UIView *subview in self.searchController.searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                [textField setKeyboardAppearance: UIKeyboardAppearanceAlert];
                textField.returnKeyType = UIReturnKeyDone;
                break;
            }
        }
    }
    

}
- (void)setSearchSource{
    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];
    
    BOOL isSortByColor = [[NSUserDefaults standardUserDefaults] boolForKey:@"isSortByColor"];
    
    switch (self.searchMode) {
        case PMSearchIdea: {
            NSDictionary *ideas = [PMDataModel current].ideas;
            self.searchSourceKeys = [[ideas.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                if (isSortByColor) {
                    ChakraEnum c1 = ((PMIdea *)ideas[(NSString *)obj1]).chakra;
                    ChakraEnum c2 = ((PMIdea *)ideas[(NSString *)obj2]).chakra;
                    return c1 > c2;
                }
                else{
                    NSString *titl1 = ((PMIdea *)ideas[(NSString *)obj1]).title;
                    NSString *titl2 = ((PMIdea *)ideas[(NSString *)obj2]).title;
                    return [titl1 compare:titl2];
                    
                }
            }] mutableCopy];
            break;
        }
        case PMSearchProto: {
            
            NSDictionary *protos = [PMDataModel current].protos;
            self.searchSourceKeys = [[protos.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *titl1 = ((PMPrototype *)protos[(NSString *)obj1]).title;
                NSString *titl2 = ((PMPrototype *)protos[(NSString *)obj2]).title;
                return [titl1 compare:titl2];
            }] mutableCopy];
            break;
        }
        case PMSearchTag: {
            
            NSDictionary *tags = [PMDataModel current].tags;
            self.searchSourceKeys = [[tags.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString *titl1 = ((PMTag *)tags[(NSString *)obj1]).title;
                NSString *titl2 = ((PMTag *)tags[(NSString *)obj2]).title;
                return [titl1 compare:titl2];
            }] mutableCopy];
            break;
            
            break;
        }
        default: {
            break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSString *title = nil;
    switch (self.searchMode) {
        case PMSearchIdea: {
            title = @"Add Idea";
            break;
        }
        case PMSearchProto: {
            title = @"Add Proto";
            break;
        }
        case PMSearchTag: {
            title = @"Add Tag";
            break;
        }
        default: {
            break;
        }
    }
    self.navigationItem.title = title;
    
    [self setSearchSource];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSUInteger count = self.searchSourceKeys.count;
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString * reuseIdentifier = @"Cell";
    PMSwipeTableCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[PMSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }


    
    PMBaseInfo *info = nil;
    // Configure the cell...
    switch (self.searchMode) {
        case PMSearchIdea: {
            info = (PMIdea *)[PMIdea ideaOfId:self.searchSourceKeys[indexPath.row]];
            
            UIColor *color = [UIColor whiteColor];
            switch (((PMIdea *)info).chakra) {
                case CharaSurvival: {
                    color = [UIColor redColor];
                    break;
                }
                case CharaEmotion: {
                    color = [UIColor orangeColor];
                    break;
                }
                case CharaPower: {
                    color = [UIColor yellowColor];
                    break;
                }
                case CharaLove: {
                    color = [UIColor greenColor];
                    break;
                }
                case CharaConnect: {
                    color = [UIColor cyanColor];
                    break;
                }
                case CharaImagination: {
                    color = [UIColor blueColor];
                    break;
                }
                case CharaSpiritual: {
                    color = [UIColor purpleColor];
                    break;
                }
                case CharaMax: {
                    break;
                }
            }
            cell.chakraView.backgroundColor = color;
            
            break;
        }
        case PMSearchProto: {
            info = (PMPrototype *)[[PMDataModel current].protos valueForKey:self.searchSourceKeys[indexPath.row]];
            
            UIColor *color = [UIColor whiteColor];
            switch (((PMPrototype *)info).chakra) {
                case CharaSurvival: {
                    color = [UIColor redColor];
                    break;
                }
                case CharaEmotion: {
                    color = [UIColor orangeColor];
                    break;
                }
                case CharaPower: {
                    color = [UIColor yellowColor];
                    break;
                }
                case CharaLove: {
                    color = [UIColor greenColor];
                    break;
                }
                case CharaConnect: {
                    color = [UIColor cyanColor];
                    break;
                }
                case CharaImagination: {
                    color = [UIColor blueColor];
                    break;
                }
                case CharaSpiritual: {
                    color = [UIColor purpleColor];
                    break;
                }
                case CharaMax: {
                    break;
                }
            }
            cell.chakraView.backgroundColor = color;
            
            break;
        }
        case PMSearchTag: {
            info = (PMTag *)[[PMDataModel current].tags valueForKey:self.searchSourceKeys[indexPath.row]];
            break;
        }
        default: {
            break;
        }
    }
    cell.textLabel.text = info.title;
    
    //configure right buttons
    MGSwipeButton *btn1 = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        switch (self.searchMode) {
            case PMSearchIdea: {
                [[PMDataModel current] deleteIdea:(PMIdea *)info];
                break;
            }
            case PMSearchProto: {
                [[PMDataModel current] deleteProto:(PMPrototype *)info];
                break;
            }
            case PMSearchTag: {
                [[PMDataModel current] deleteTag:(PMTag *)info];
                break;
            }
            default: {
                break;
            }
        }
        [self setSearchSource];
        [self.tableView reloadData];
        
        return YES;
    }];
    
    MGSwipeButton *btn2 = [MGSwipeButton buttonWithTitle:@"Chakra" backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell *sender) {
        switch (self.searchMode) {
            case PMSearchIdea: {
                [self presentAlertControllerWithTitle:@"Select Chakra" message:nil fromView:nil actionHandler:^(NSInteger actionIndex) {
                    ((PMIdea *)info).chakra = actionIndex;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                } cancelButtonTitle:nil otherButtonTitles:
                 @"Survival",
                 @"Emotion",
                 @"Power",
                 @"Love",
                 @"Connect",
                 @"Imagination",
                 @"Spiritual",
                 nil];
                
                break;
            }
            case PMSearchProto: {
                [self presentAlertControllerWithTitle:@"Select Chakra" message:nil fromView:nil actionHandler:^(NSInteger actionIndex) {
                    ((PMPrototype *)info).chakra = actionIndex;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                } cancelButtonTitle:nil otherButtonTitles:
                 @"Survival",
                 @"Emotion",
                 @"Power",
                 @"Love",
                 @"Connect",
                 @"Imagination",
                 @"Spiritual",
                 nil];
                break;
                
            }
            case PMSearchTag: {
                break;
            }
            default: {
                break;
            }
        }
        [self setSearchSource];
        [self.tableView reloadData];
        
        return YES;
    }];
    
    cell.rightButtons = @[btn1, btn2];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.navigationController popViewControllerAnimated:true];
    
    switch (self.searchMode) {
        case PMSearchIdea: {
            if (self.delegate) {
                PMIdea *idea = [PMIdea ideaOfId:self.searchSourceKeys[indexPath.row]];
                [self.delegate willAddBaseInfo:idea];
            }
            
            break;
        }
        case PMSearchProto: {
            if (self.delegate) {
                PMPrototype *proto = [[PMDataModel current].protos valueForKey:self.searchSourceKeys[indexPath.row]];
                [self.delegate willAddBaseInfo:proto];
            }

            break;
        }
        case PMSearchTag: {
            if (self.delegate) {
                PMTag *tag = [[PMDataModel current].tags valueForKey:self.searchSourceKeys[indexPath.row]];
                [self.delegate willAddBaseInfo:tag];
            }
       
            break;
        }
        default: {
            break;
        }
    }
    

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
//    NSString *scope = nil;
//    
//    NSInteger selectedScopeButtonIndex = [self.searchController.searchBar selectedScopeButtonIndex];
//    if (selectedScopeButtonIndex > 0) {
//        scope = [[Product deviceTypeNames] objectAtIndex:(selectedScopeButtonIndex - 1)];
//    }
//    
    [self updateFilteredContentForName:searchString];
    
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        
        PMSearchResultsTableViewController *vc = (PMSearchResultsTableViewController *)navController.topViewController;
        vc.searchResultIds = self.searchResultKeys;
        vc.searchMode = self.searchMode;
        [vc.tableView reloadData];
    }
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
//- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
//    [self updateSearchResultsForSearchController:self.searchController];
//}


#pragma mark - Content Filtering

- (void)updateFilteredContentForName:(NSString *)name {
    
    // Update the filtered array based on the search text and scope.
    if ((name == nil) || [name length] == 0) {
        // If there is no search string and the scope is "All".
        self.searchResultKeys = [self.searchSourceKeys mutableCopy];

        return;
    }
    
    
    [self.searchResultKeys removeAllObjects]; // First clear the filtered array.
    
    /*  Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
     */
    for (NSString *identifier in self.searchSourceKeys) {
        NSString *sourceTitle = nil;
        //compare the title of the identifered idea or prototype with name typed
        switch (self.searchMode) {
            case PMSearchIdea: {
                sourceTitle = ((PMIdea *)[PMIdea ideaOfId:identifier]).title;
                break;
            }
            case PMSearchProto: {
                sourceTitle = ((PMPrototype *)[[PMDataModel current].protos valueForKey:identifier]).title;
                break;
            }
            case PMSearchTag: {
                sourceTitle = ((PMTag *)[[PMDataModel current].tags valueForKey:identifier]).title;
                break;
            }
            default: {
                break;
            }
        }
        

        NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
        NSRange nameRange = NSMakeRange(0, sourceTitle.length);
        NSRange foundRange = [sourceTitle rangeOfString:name options:searchOptions range:nameRange];
        if (foundRange.length > 0) {
            [self.searchResultKeys addObject:identifier];
        }
    }
}

#pragma mark- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //add searchBar text to library
    [self dismissViewControllerAnimated:true completion:^{
        [self.navigationController popViewControllerAnimated:true];
        if (self.searchMode == PMSearchIdea) {
            PMIdea *idea = [PMIdea ideaWithTitle:searchBar.text desc:@""];
            [[PMDataModel current] addIdea:idea];
            
            if (self.delegate) {
                [self.delegate willAddBaseInfo:idea];
            }
        }
        else if (self.searchMode == PMSearchProto) {
            PMPrototype *proto = [PMPrototype prototypeWithTitle:searchBar.text desc:@""];
            [[PMDataModel current] addProto:proto];
            
            if (self.delegate) {
                [self.delegate willAddBaseInfo:proto];
            }
        }
        else if (self.searchMode == PMSearchTag) {
            PMTag *tag = [PMTag tagWithTitle:searchBar.text];
            [[PMDataModel current] addTag:tag];
            
            if (self.delegate) {
                [self.delegate willAddBaseInfo:tag];
            }
        }
    }];

}

#pragma mark- PMSearchresultsTableViewControllerDelegate
- (void)willAddSearchResults:(PMBaseInfo *)baseInfo{
    __block PMBaseInfo *info = baseInfo;
    [self dismissViewControllerAnimated:true completion:^{
        [self.navigationController popToRootViewControllerAnimated:true];
        
        if (self.delegate) {
            [self.delegate willAddBaseInfo:info];
        }
    }];
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
