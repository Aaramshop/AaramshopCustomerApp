//
//  LocationTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 31/07/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"


@protocol LocationListCellDelegate <NSObject>

-(void)deleteLocationList:(NSInteger)index;
@end

@interface LocationTableCell : UITableViewCell

{
	
   
	__weak IBOutlet UILabel *lblTitle;
	__weak IBOutlet UILabel *lblAddress;
}
@property (weak, nonatomic) IBOutlet UIButton *deletebtn;
//@property (weak, nonatomic) IBOutlet UIButton *deleteCell;
@property (weak, nonatomic) IBOutlet UIButton *deleteCell;
@property(nonatomic,weak) id <LocationListCellDelegate>delegate;
//@property(nonatomic,strong) NSIndexPath *indexPath;


@property (nonatomic, strong) NSIndexPath *indexPath;
//- (void)updateCellWithData: (AddressModel *)addressModel;

- (void)updateCellWithData: (AddressModel *)addressModel;
@end
