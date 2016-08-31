//
//  PMRelatedViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/7/1.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "PMRelatedViewController.h"
#import "PMRelatedTableViewCell.h"
#import "PMDetailViewController.h"
#import "PMCompareViewController.h"
#import "PMDataModel.h"
#import "PMDataViewController.h"
@interface PMRelatedViewController ()
<UITableViewDataSource,
UITableViewDelegate
>
@property (retain, nonatomic) NSArray *relatedProtoIds;
@end

@implementation PMRelatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tableView.allowsMultipleSelection = true;
    
    
    //MARK:feed test data
    NSString *protoId1 = [PMPrototype protoIdOfTitle:@"Journey"];
    NSString *protoId2 = [PMPrototype protoIdOfTitle:@"Minecraft"];
    self.relatedProtoIds = @[protoId1, protoId2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = [NSString stringWithFormat:@"Related of %@", self.detailInfo.title];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.relatedProtoIds.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * reuseIdentifier = @"Cell";
    PMRelatedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[PMRelatedTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    
    PMPrototype *proto = [PMPrototype protoOfId:self.relatedProtoIds[indexPath.row]];
    cell.textLabel.text = proto.title;
    cell.tag = indexPath.row;
    
    return cell;
}
#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //only allow two cell selection
    
}

#pragma mark- tool
/**
 *  对相关的创意按排序元素进行排序
 */
- (void)sortRelatedProtoIds{
    
}

#pragma mark- IBAction
- (IBAction)sortButtonTouchUp:(UIBarButtonItem *)sender {
    [RemoteLog logAction:@"sortButtonTouchUp" fromSender:sender withParameters:nil timed:NO];
}

- (IBAction)sortByTypeButtonTouchUP:(UIBarButtonItem *)sender {
    [RemoteLog logAction:@"sortButtonTouchUp" fromSender:sender withParameters:nil timed:NO];
}

- (IBAction)compareButtonTouchUp:(UIBarButtonItem *)sender {
    [RemoteLog logAction:@"compareButtonTouchUp" fromSender:sender withParameters:nil timed:NO];
    
}

- (IBAction)pickButtonTouchUp:(UIBarButtonItem *)sender {
    [RemoteLog logAction:@"pickButtonTouchUp" fromSender:sender withParameters:nil timed:NO];
    NSString *protoId = self.relatedProtoIds[[self.tableView indexPathForSelectedRow].row];
    if (![[PMDataModel current].protoIdCollection containsObject:protoId]) {
        [[PMDataModel current].protoIdCollection addObject:protoId];
    }
    
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UITableViewCell *cell = sender;
    if ([segue.identifier isEqualToString:@"pushCompareView"]) {
        PMCompareViewController *vc = (PMCompareViewController *)segue.destinationViewController;
        vc.srcProtoId = self.detailInfo.identifier;
        NSInteger index = self.tableView.indexPathForSelectedRow.row;
        vc.destProtoId = self.relatedProtoIds[index];
    }
    else if ([segue.identifier isEqualToString:@"pushDetailView"]) {
        
        PMPrototype *proto = [PMPrototype protoOfId:self.relatedProtoIds[cell.tag]];
        [PMDataViewController sharedInstance].curProto = proto;
        
        PMDetailViewController *vc = (PMDetailViewController *)segue.destinationViewController;
        vc.detailInfo = [PMDataViewController sharedInstance].curProto;
        
    }
}

@end
