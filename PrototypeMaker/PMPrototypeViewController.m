//
//  PMPrototypeViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMPrototypeViewController.h"
#import "PMDataModel.h"
#import "PMDocument.h"
//#import "MSCMoreOptionTableViewCell.h"kPMDocumentDownloadedFromiCloud
#import "PMSearchTableViewController.h"
#import "PMDetailViewController.h"
#import "PMDataViewController.h"
#import "PMIdeaViewController.h"
#import "DPiCloudDocManager.h"
#import "PMSwipeTableCell.h"

@interface PMPrototypeViewController ()
<UITableViewDataSource,
UITableViewDelegate,
UITabBarControllerDelegate,
UINavigationControllerDelegate,
MGSwipeTableCellDelegate,
PMIdeaViewControllerDelegate,
PMSearchTableViewControllerDelegate,
DPiCloudDocManagerDelegate
>
@end

@implementation PMPrototypeViewController

- (void)viewDidLoad {
    DebugLog(@"viewDidLoad");
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.allowsMultipleSelection = true;
    self.navigationController.delegate = self;
    self.tabBarController.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDownloaded) name:kPMDocumentDownloadedFromiCloud object:nil];
    
    [DPiCloudDocManager si].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    DebugLogSystem(@"viewWillAppear");
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    DebugLogSystem(@"viewDidAppear");
    
    [self documentNeedDisplay];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    DebugLogSystem(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    DebugLogSystem(@"viewDidLayoutSubviews");
}

- (void)documentDownloaded{
    [self documentNeedDisplay];
}

- (void)documentNeedDisplay{
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    
    if(vc.curIdea){
        self.curCollection = [[PMDataViewController sharedInstance].curIdea protoIds];
        
        self.navigationItem.title = [NSString stringWithFormat:@"Protos of %@", vc.curIdea.title];
    }
    else{
        self.curCollection = [PMDataModel current].protoIdCollection;
        
        self.navigationItem.title = @"Protos";
    }
    
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    DebugLog(@"dealloc protoVC");
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.curCollection.count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier = @"Cell";
    PMSwipeTableCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[PMSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    PMPrototype *pt = [PMPrototype protoOfId:self.curCollection[indexPath.row]];
    cell.textLabel.text = pt.title;
    cell.imageView.image = pt.pinned ? [UIImage imageNamed:@"pin.png"] : nil;
    cell.delegate = self; //optional
    cell.tag = indexPath.row;
    
    UIColor *color = [UIColor whiteColor];
    switch (pt.chakra) {
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
        pt.pinned = false;
        [self removeProto:pt];
        [self.tableView reloadData];
        
        return YES;
    }];
    
    NSString *title = pt.pinned ? @"Unpin" : @"Pin";
    MGSwipeButton *btn2 = [MGSwipeButton buttonWithTitle:title backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell *sender) {
        pt.pinned = !pt.pinned;
        [self.tableView reloadData];
        
        return YES;
    }];
    
    MGSwipeButton *btn3 = [MGSwipeButton buttonWithTitle:@"Chakra" backgroundColor:[UIColor greenColor] callback:^BOOL(MGSwipeTableCell *sender) {
        
        [self presentAlertControllerWithTitle:@"Select Chakra" message:nil fromView:nil actionHandler:^(NSInteger actionIndex) {
            pt.chakra = actionIndex;
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"tableView didSelectRowAtIndexPath %zd", indexPath.row);
//    PMPrototype *proto = [PMPrototype protoOfId:self.curCollection[indexPath.row]];
//    [PMDataViewController sharedInstance].curProto = proto;
    
    self.selectedIndex = indexPath.row;
}

- (void)addProto:(PMPrototype *)proto{
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curIdea){
        [vc.curIdea addPrototype:proto];
    }
    else{
        [self.curCollection addObject:proto.identifier];
    }
}

- (void)removeProto:(PMPrototype *)proto{
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curIdea){
        [vc.curIdea deletePrototype:proto];
    }
    else{
        [self.curCollection removeObject:proto.identifier];
    }
}

- (IBAction)flushFromIdeas:(UIBarButtonItem *)sender {
    NSMutableArray *protoIds = [[PMDataModel current] protoIdsFromIdeaIds:[PMDataModel current].ideaIdCollection];
    while(self.curCollection.firstObject) {
        PMPrototype *pt = [PMPrototype protoOfId:self.curCollection.firstObject];
        [self removeProto:pt];
    }
    
    for (NSString *ptId in protoIds) {
        PMPrototype *pt = [PMPrototype protoOfId:ptId];
        [self addProto:pt];
    }
    [self.tableView reloadData];
}

- (IBAction)rollProtoButtonTouchUp:(UIBarButtonItem *)sender {
    NSArray *array = [[PMDataModel current].protos allKeys];
    if (array.count == 0) {
        return;
    }

    
    //remove unpinned record
    NSMutableArray *collectionCopy = [self.curCollection copy];
    for (int i = 0; i < collectionCopy.count; ++i) {
        PMPrototype *pt = [PMPrototype protoOfId:collectionCopy[i]];
        //pinned with tag 1
        if(!pt.pinned){
            [self removeProto:pt];
        }
    }
        
    NSUInteger numOfRollProto = [[NSUserDefaults standardUserDefaults] integerForKey:@"numOfRollProto"];
    numOfRollProto = MAX(0, (numOfRollProto - self.curCollection.count));
    
    int i = 0;
    
    int random = arc4random()%[array count];
    NSString *key = [array objectAtIndex:random];
    PMPrototype *proto = [PMPrototype protoOfId:key];
    
    while (i < numOfRollProto) {
        //如果不存在，加入，存在，则继续roll
        if(![self.curCollection containsObject:proto.identifier]){
            [self addProto:proto];
            i++;
        }
        
        random = arc4random()%[array count];
        NSString *key = [array objectAtIndex:random];
        proto = [PMPrototype protoOfId:key];
    }
    
    [self.tableView reloadData];
}

- (IBAction)searchButtonTouchUp:(UIBarButtonItem *)sender {
}

- (IBAction)clearButtonTouchUp:(UIBarButtonItem *)sender{
    while (self.curCollection.firstObject) {
        PMPrototype *proto = [PMPrototype protoOfId:self.curCollection.firstObject];
        proto.pinned = false;
        [self removeProto:proto];
    }
    
    [self.tableView reloadData];

}

- (IBAction)importFromBundleTouchUp:(UIButton *)sender {
    [[DPiCloudDocManager si] loadDataFromJson];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    MGSwipeTableCell *cell = sender;
    if ([segue.identifier isEqual:@"search"]) {
        PMSearchTableViewController *vc = segue.destinationViewController;
        vc.searchMode = PMSearchProto;
        vc.delegate = self;
    }
    else if ([segue.identifier isEqual:@"pushDetailView"]) {
//        self.navigationController.navigationBarHidden = false;
        
        /**
         *  进入具体原型后，idea tab的数据源取切换至该原型的idea
         */
        PMPrototype *proto = [PMPrototype protoOfId:self.curCollection[cell.tag]];
        [PMDataViewController sharedInstance].curProto = proto;
        
        PMDetailViewController *vc = (PMDetailViewController *)segue.destinationViewController;
        vc.detailInfo = [PMDataViewController sharedInstance].curProto;
    }
    
}

- (IBAction)ideaOfProtoButtonTouchUp:(UIBarButtonItem *)sender {
    DebugLog(@"ideaOfProtoButtonTouchUp");
    
    PMPrototype *proto = [PMPrototype protoOfId:self.curCollection[self.selectedIndex]];
    [PMDataViewController sharedInstance].curProto = proto;

    self.tabBarController.selectedIndex = 1;
    self.selectedIndex = 0;
}

#pragma mark- PMSearchResultsTableViewControllerDelegate
- (void)willAddBaseInfo:(PMBaseInfo *)baseInfo{
    PMPrototype *proto = (PMPrototype *)baseInfo;
    
    NSMutableArray *array = nil;
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curIdea){
        [[PMDataModel current] connectProto:proto withIdea:vc.curIdea];
        array = [[PMDataViewController sharedInstance].curIdea protoIds];
    }
    else{
        array = [PMDataModel current].protoIdCollection;
    }
    
    if (![array containsObject:proto.identifier]) {
        [array addObject:proto.identifier];
    }
}
#pragma mark- UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[PMDetailViewController class]]) {
        [PMDataViewController sharedInstance].isIdeaTabDataSourceDirty = true;
    }
    else if ([viewController isKindOfClass:[PMPrototypeViewController class]]) {
        //在离开detailViewController时候需要重置
        [PMDataViewController sharedInstance].curProto = nil;
//        [self documentNeedDisplay];
    }
}
#pragma mark- UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    DebugLog(@"tabBarController didSelectViewController %@", viewController.title);
    
    PMIdeaViewController *vc = (PMIdeaViewController *)((UINavigationController *)viewController).topViewController;
    vc.delelgate = self;
}

#pragma mark- PMIdeaViewControllerDelegate
- (void)didMakePrototype:(PMPrototype *)proto{
    PMDetailViewController *vc =  [self.storyboard instantiateViewControllerWithIdentifier:@"PMDetailViewController"];
    [self.navigationController pushViewController:vc animated:true];
    vc.detailInfo = proto;
}

#pragma mark- DPiCloudDocManagerDelegate
- (void)debugExportFileURL:(NSURL *)url{
    [UIActivityViewController airdropFileURL:url inViewController:self];
}

#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
