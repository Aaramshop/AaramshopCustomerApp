//
//  PickLastTableCell.h
//  AaramShop
//
//  Created by Approutes on 23/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickCollectionViewController.h"

@interface PickLastTableCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
{
    __weak IBOutlet UIView *subview;
    
}
@property (nonatomic, strong) NSIndexPath *indexPath;
-(void)updateCellWithData:(NSDictionary  *)inDataDic;
@end
