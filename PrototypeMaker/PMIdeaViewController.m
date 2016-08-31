//
//  PMIdeaViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMIdeaViewController.h"
#import "PMDataModel.h"
#import "PMDocument.h"
#import "PMSearchTableViewController.h"
#import "PMDataViewController.h"
#import "PMDetailViewController.h"
#import "PMSwipeTableCell.h"
#define ARC4RANDOM_MAX      0x100000000

@interface PMIdeaViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITabBarControllerDelegate,
MGSwipeTableCellDelegate,
UINavigationControllerDelegate,
PMSearchTableViewControllerDelegate
>
@end

@implementation PMIdeaViewController

- (void)viewDidLoad {
    DebugLogSystem(@"viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.allowsMultipleSelection = true;
    self.navigationController.delegate = self;
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDownloaded) name:kPMDocumentDownloadedFromiCloud object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    DebugLogSystem(@"viewWillAppear");
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    
    [self documentNeedDisplay];
}

- (void)viewDidAppear:(BOOL)animated{
    DebugLogSystem(@"viewDidAppear");
    [super viewDidAppear:animated];
}

- (void)documentDownloaded{
    [self documentNeedDisplay];
}

- (void)documentNeedDisplay{
    //判断使用什么数据来显示
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curProto){
        self.curCollection = [[PMDataViewController sharedInstance].curProto ideaIds];
        
        //ui
        self.navigationItem.title = [NSString stringWithFormat:@"Ideas of %@", vc.curProto.title];
    }
    else{
        self.curCollection = [PMDataModel current].ideaIdCollection;
        
        self.navigationItem.title = @"Ideas";
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    DebugLogSystem(@"dealloc ideaVC");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMDocumentDownloadedFromiCloud object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.curCollection.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier = @"Cell";
    PMSwipeTableCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[PMSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    PMIdea *idea = [PMIdea ideaOfId:self.curCollection[indexPath.row]];
    cell.textLabel.text = idea.title;
    cell.imageView.image = idea.pinned ? [UIImage imageNamed:@"pin.png"] : nil;
    cell.delegate = self; //optional
    cell.tag = indexPath.row;
    
    UIColor *color = [UIColor whiteColor];
    switch (idea.chakra) {
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
    
    //configure right buttons
    MGSwipeButton *btn1 = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        [self removeIdea:idea];
        [self.tableView reloadData];
  
        return YES;
    }];
    
    NSString *title = idea.pinned ? @"Unpin" : @"Pin";
    MGSwipeButton *btn2 = [MGSwipeButton buttonWithTitle:title backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell *sender) {
        idea.pinned = !idea.pinned;
        [self.tableView reloadData];
        
        return YES;
    }];
    
    MGSwipeButton *btn3 = [MGSwipeButton buttonWithTitle:@"Chakra" backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell *sender) {
        
        [self presentAlertControllerWithTitle:@"Select Chakra" message:nil fromView:nil actionHandler:^(NSInteger actionIndex) {
            idea.chakra = actionIndex;
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
        
        return YES;
    }];

    
    cell.rightButtons = @[btn1, btn2, btn3];
    
    return cell;
}
#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"tableView didSelectRowAtIndexPath %zd", indexPath.row);
    if (self.tableView.indexPathsForSelectedRows.count > 0) {
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Prototype" style:UIBarButtonItemStyleDone target:self action:@selector(makeProto)];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"tableView didDeselectRowAtIndexPath %zd", indexPath.row);
    if (self.tableView.indexPathsForSelectedRows.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark- UIAction
- (void)addIdea:(PMIdea *)idea{
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curProto){
        [vc.curProto addIdea:idea];
    }
    else{
        [self.curCollection addObject:idea.identifier];
    }
}

- (void)removeIdea:(PMIdea *)idea{
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curProto){
        [vc.curProto deleteIdea:idea];
    }
    else{
        [self.curCollection removeObject:idea.identifier];
    }
}

- (IBAction)flushFromProtos:(UIBarButtonItem *)sender {
    NSMutableArray *ideaIds = [[PMDataModel current] ideaIdsFromProtoIds:[PMDataModel current].protoIdCollection];
    while(self.curCollection.firstObject) {
        PMIdea *idea = [PMIdea ideaOfId:self.curCollection.firstObject];
        [self removeIdea:idea];
    }
    
    for (NSString *ideaId in ideaIds) {
        PMIdea *idea = [PMIdea ideaOfId:ideaId];
        [self addIdea:idea];
    }
    
    [self.tableView reloadData];
}

- (IBAction)searchButtonTouchUp:(UIBarButtonItem *)sender {
}

- (IBAction)rollIdeaButtonTouchUp:(UIBarButtonItem *)sender {

    //remove unpinned record
    NSMutableArray *collectonCopy = [self.curCollection copy];
    for (int i = 0; i < collectonCopy.count; ++i) {
        PMIdea *idea = [PMIdea ideaOfId:collectonCopy[i]];
        //pinned with tag 1
        if(!idea.pinned){
            [self removeIdea:idea];
        }
    }
    
    NSUInteger numOfRollIdea = [[NSUserDefaults standardUserDefaults] integerForKey:@"numOfRollIdea"];
    numOfRollIdea = MAX(0, (numOfRollIdea - self.curCollection.count));
    NSArray *array = [[PMDataModel current].ideas allKeys];

    int i = 0;
    int random = arc4random()%[array count];
    NSString *key = [array objectAtIndex:random];
    PMIdea *idea = [PMIdea ideaOfId:key];
    
    while (i < numOfRollIdea) {
        //如果不存在，加入，存在，则继续roll
        if(![self.curCollection containsObject:idea.identifier]){
            [self addIdea:idea];
            i++;
        }
        
        random = arc4random()%[array count];
        NSString *key = [array objectAtIndex:random];
        idea = [PMIdea ideaOfId:key];
    }
    
    [self.tableView reloadData];
}

- (IBAction)clearButtonTouchUp:(UIBarButtonItem *)sender{
    while (self.curCollection.firstObject) {
        PMIdea *idea = [PMIdea ideaOfId:self.curCollection.firstObject];
        idea.pinned = false;
        [self removeIdea:idea];
    }

    [self.tableView reloadData];
}

- (void)makeProto{
    self.navigationItem.rightBarButtonItem = nil;
    
    PMPrototype *proto = [PMPrototype prototypeWithTitle:@"New Title" desc:@"Enter the desc"];
    [[PMDataModel current] addProto:proto];
    
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        PMIdea *idea = [PMIdea ideaOfId:self.curCollection[indexPath.row]];
        [[PMDataModel current] connectProto:proto withIdea:idea];
    }
    
    [[PMDataModel current].protoIdCollection addObject:proto.identifier];
    
    //switch to proto tab and into new title's detail
    [PMDataViewController sharedInstance].curProto = proto;
    
    self.tabBarController.selectedIndex = 0;
    
    if (self.delelgate) {
        [self.delelgate didMakePrototype:proto];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    MGSwipeTableCell *cell = sender;
    
    if ([segue.identifier isEqual:@"search"]) {
        PMSearchTableViewController *vc = segue.destinationViewController;
        vc.searchMode = PMSearchIdea;
        vc.delegate = self;
    }
    else if ([segue.identifier isEqual:@"pushDetailView"]) {
        //        self.navigationController.navigationBarHidden = false;
        
        /**
         *  进入具体原型后，idea tab的数据源取切换至该原型的idea
         */
        
        PMIdea *idea = [PMIdea ideaOfId:self.curCollection[cell.tag]];
        [PMDataViewController sharedInstance].curIdea = idea;
        
        PMDetailViewController *vc = (PMDetailViewController *)segue.destinationViewController;
        vc.detailInfo = idea;
    }
}

#pragma mark- PMSearchResultsTableViewControllerDelegate
- (void)willAddBaseInfo:(PMBaseInfo *)baseInfo{
    PMIdea *idea = (PMIdea *)baseInfo;
    
    NSMutableArray *array = nil;
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curProto){
        [[PMDataModel current] connectProto:vc.curProto withIdea:idea];
        array = [[PMDataViewController sharedInstance].curProto ideaIds];
    }
    else{
        array = [PMDataModel current].ideaIdCollection;
    }
    
    if (![array containsObject:idea.identifier]) {
        [array addObject:idea.identifier];
    }
}

#pragma mark- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    DebugLog(@"navigationController willShowViewController %@", viewController.title);
    if ([viewController isKindOfClass:[PMDetailViewController class]]) {
        [PMDataViewController sharedInstance].isProtoTabDataSourceDirty = true;
        [PMDataViewController sharedInstance].isTagTabDataSourceDirty = true;
    }
    else if ([viewController isKindOfClass:[PMIdeaViewController class]]) {
        //在离开detailViewController时候需要重置
        [PMDataViewController sharedInstance].curIdea = nil;
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    DebugLog(@"navigationController didShowViewController %@", viewController.title);
}

#pragma mark- UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    DebugLog(@"tabBarController didSelectViewController %@", viewController.title);
}
#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
