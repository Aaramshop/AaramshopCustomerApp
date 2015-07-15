//
//  UserContactTableCell.h
//  AaramShop
//
//  Created by Arbab Khan on 02/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
//====================================
@protocol delegateTextFieldValue <NSObject>
@optional

-(void)EndEditingInsideTable:(UITextField *)textField;

@end
@interface UserContactTableCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) PWTextField *txtEmail;
@property (nonatomic, strong) UILabel *lblDetail;
@property (nonatomic, strong) UILabel *lblChangePass;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (weak,nonatomic) id <delegateTextFieldValue> delegateFetchValue;

@end
