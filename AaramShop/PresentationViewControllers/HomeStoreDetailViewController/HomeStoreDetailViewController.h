//
//  HomeStoreDetailViewController.h
//  AaramShop
//
//  Created by Approutes on 08/06/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeStoreDetailViewController : UIViewController
{
    
    __weak IBOutlet UILabel *lblTitle;
}
- (IBAction)btnStartShoppingClick:(UIButton *)sender;
@end
