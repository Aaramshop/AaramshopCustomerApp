//
//  AccountSettingsViewC.h
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoTableCell.h"
#import "UserContactTableCell.h"
#import "ChangePasswordViewController.h"
typedef enum
{
	
    eUserInfo = 0,
    eUserContact
}eSectionType;

@interface AccountSettingsViewC : UIViewController<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
//	NSString *strFirstName
    __weak IBOutlet UITableView *tblView;
	UIImageView * imgUser;
	NSMutableData *imageData;

}
@end
