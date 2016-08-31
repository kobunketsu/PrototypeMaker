
//
//  PMCompareViewController.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/7/5.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "PMCompareViewController.h"
#import "PMDetailViewController.h"
#import "PMIdeaViewController.h"
#import "PMDataModel.h"
#import "PMDataViewController.h"
@interface PMCompareViewController()
<UITableViewDataSource,
UITableViewDelegate
>

@property (retain, nonatomic) NSArray *sharedIdeaIds;
@end

@implementation PMCompareViewController

- (void)viewDidLoad{
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    PMPrototype *vs1ProtoId = [PMPrototype protoOfId:self.srcProtoId];
    PMPrototype *vs2ProtoId = [PMPrototype protoOfId:self.destProtoId];
    self.title = [NSString stringWithFormat:@"%@ VS %@", vs1ProtoId.title, vs2ProtoId.title];
}
#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    if (section == 0) {
        num = [self sharedIdeaIds].count;
    }
    else if (section == 1) {
        
    }
    return num;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DebugLog(@"tableView cellForRowAtIndexPath %zd", indexPath.row);
    if(indexPath.section == 0){
        static NSString * reuseIdentifier = @"Cell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        }
        
        //configure
        cell.textLabel.text = [PMIdea ideaOfId:self.sharedIdeaIds[indexPath.row]].title;
        cell.tag = indexPath.row;
        
        return cell;
    }
    else if(indexPath.section == 1){
        static NSString * reuseIdentifier = @"ContainerCell";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        }
        return cell;
    }

    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Shared";
    }

    return nil;
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    self.tabBarController.selectedIndex = 1;
    
    [PMDataViewController sharedInstance].curIdea = [PMIdea ideaOfId:self.sharedIdeaIds[indexPath.row]];
    
//    PMIdeaViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PMIdeaViewController"];
//    [self.navigationController popToRootViewControllerAnimated:true];
//    [self.navigationController performSegueWithIdentifier:@"pushDetailView" sender:self];
}

#pragma mark- IBAction
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    self.tabBarController.selectedIndex = 1;
    UITableViewCell *cell = sender;
    
    if ([segue.identifier isEqualToString:@"pushDetailView"]) {
        PMIdea *idea = [PMIdea ideaOfId:self.sharedIdeaIds[cell.tag]];
        [PMDataViewController sharedInstance].curIdea = idea;
        
        PMDetailViewController *vc = (PMDetailViewController *)segue.destinationViewController;
        vc.detailInfo = idea;
    }
}

#pragma mark- Calculate SharedIdea
- (NSArray *)sharedIdeaIds{
    if (!_sharedIdeaIds) {
        PMPrototype *srcProto = [PMPrototype protoOfId:self.srcProtoId];
        _sharedIdeaIds = [srcProto intersectionIdeaIdsOfProtoId:self.destProtoId];
    }
    return _sharedIdeaIds;
}

@end
