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
typedef enum
{
    eChangeSelfie = 0,
    eUserInfo,
    eUserContact
}eSectionType;

@interface AccountSettingsViewC : UIViewController
{
    NSMutableArray *arrUserInfo;
    NSMutableArray *arrUserContact;
    NSMutableArray *allSections;
    NSMutableDictionary *dataDict;
    __weak IBOutlet UITableView *tblView;
}
@end
