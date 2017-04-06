//
//  AddStoreTableViewCell.h
//  AaramShop
//
//  Created by Riteshk Gupta on 03/04/17.
//  Copyright © 2017 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteStoreListCell <NSObject>

-(void)deleteStoreList:(NSInteger)index;
@end
@interface AddStoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *storeImgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLbl;
- (IBAction)deleteStore:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *deleteStoreOut;
@property(nonatomic,weak) id <DeleteStoreListCell>adelegate;
@property (nonatomic, strong) NSIndexPath *indexPath1;


@end
