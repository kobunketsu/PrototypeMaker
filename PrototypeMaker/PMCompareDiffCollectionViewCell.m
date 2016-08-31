//
//  PMCompareDiffCollectionViewCell.m
//  PrototypeMaker
//
//  Created by 文杰 胡 on 15/7/6.
//  Copyright (c) 2015年 文杰 胡. All rights reserved.
//

#import "PMCompareDiffCollectionViewCell.h"

@implementation PMCompareDiffCollectionViewCell


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseIdentifier = @"Cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    }
    return cell;
}
@end
