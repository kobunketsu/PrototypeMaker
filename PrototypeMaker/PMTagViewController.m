//
//  PMTagViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 6/13/15.
//  Copyright (c) 2015 文杰 胡. All rights reserved.
//

#import "PMTagViewController.h"
#import "PMSearchTableViewController.h"
#import "PMDataViewController.h"
#import "PMDataModel.h"
#import "PMDocument.h"

@interface PMTagViewController ()
<UITableViewDataSource,
UITableViewDelegate,
MGSwipeTableCellDelegate,
PMSearchTableViewControllerDelegate
>
@end

@implementation PMTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentDownloaded) name:kPMDocumentDownloadedFromiCloud object:nil];    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
    [self documentNeedDisplay];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.curCollection = nil;
}

- (void)documentDownloaded{
    DebugLog(@"documentDownloaded");
    [self documentNeedDisplay];
}

- (void)documentNeedDisplay{
    //判断使用什么数据来显示
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curIdea){
        //将创意相关的标示显示出来
        self.curCollection = [vc.curIdea tagIds];
        self.navigationItem.title = [NSString stringWithFormat:@"Tags of %@", vc.curIdea.title];
    }
    else{
        //自定义标示组，用于给出创意时添加过滤器
        self.curCollection = [PMDataModel current].tagIdCollection;
        
        self.navigationItem.title = @"Filter Tags for Ideas";
    }
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    DebugLog(@"dealloc tagVC");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPMDocumentDownloadedFromiCloud object:nil];
}
#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.curCollection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier = @"Cell";
    
    __weak PMTagViewController *weakSelf = self;
    MGSwipeTableCell * cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    __block PMTag *tag = [PMTag tagOfId:self.curCollection[indexPath.row]];
    cell.textLabel.text = tag.title;
    cell.imageView.image = tag.pinned ? [UIImage imageNamed:@"pin.png"] : nil;
    cell.delegate = self; //optional
    cell.tag = indexPath.row;
    
    //configure right buttons
    MGSwipeButton *btn1 = [MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor] callback:^BOOL(MGSwipeTableCell *sender) {
        
        PMDataViewController *vc = [PMDataViewController sharedInstance];
        if(vc.curIdea){
            PMIdea *idea = vc.curIdea;
            [idea deleteTag:tag];
            [self.curCollection removeObject:tag.identifier];
        }
        else{
            [self.curCollection removeObjectAtIndex:indexPath.row];
        }
        
        [self.tableView reloadData];
        
        return YES;
    }];
    
    MGSwipeButton *btn2 = [MGSwipeButton buttonWithTitle:@"Rename" backgroundColor:[UIColor darkGrayColor] callback:^BOOL(MGSwipeTableCell *sender) {
        __block UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Rename" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.text = tag.title;
        }];
        UIAlertAction *ac = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            UITextField *tf = alert.textFields[0];
            tag.title = tf.text;
            [weakSelf.tableView reloadData];
        }];
        [alert addAction:ac];
        ac = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alert addAction:ac];
        [self presentViewController:alert animated:true completion:nil];
        
        return YES;
    }];
    
    NSString *title = tag.pinned ? @"Unpin" : @"Pin";
    MGSwipeButton *btn3 = [MGSwipeButton buttonWithTitle:title backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell *sender) {
        tag.pinned = !tag.pinned;
        [self.tableView reloadData];
        
        return YES;
    }];
    
    cell.rightButtons = @[btn1, btn3, btn2];
    
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clearButtonTouchUp:(UIBarButtonItem *)sender {
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    if(vc.curIdea){
        NSMutableArray *array = [self.curCollection copy];
        for (NSString *tagId in array) {
            PMTag *tag = [PMTag tagOfId:tagId];
            [vc.curIdea deleteTag:tag];
        }
    }
    else{
        [self.curCollection removeAllObjects];
    }
    
    [self.tableView reloadData];
}

- (IBAction)addButtonTouchUp:(UIBarButtonItem *)sender {
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqual:@"search"]) {
        PMSearchTableViewController *vc = segue.destinationViewController;
        vc.searchMode = PMSearchTag;
        vc.delegate = self;
    }
}


#pragma mark- PMSearchResultsTableViewControllerDelegate
- (void)willAddBaseInfo:(PMBaseInfo *)baseInfo{
    
    //data
    PMDataViewController *vc = [PMDataViewController sharedInstance];
    NSMutableArray *array = nil;
    if(vc.curIdea){
        array = [vc.curIdea tagIds];
    }
    else{
        array = [PMDataModel current].tagIdCollection;
    }
    
    if (![array containsObject:baseInfo.identifier]) {
        [array addObject:baseInfo.identifier];
    }
}

#ifdef _DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
@end
