//
//  PrescriptionViewController.h
//  AaramShop
//
//  Created by Approutes on 04/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptionViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    __weak IBOutlet UIImageView *imgBackground;
    __weak IBOutlet UIImageView *imgPrescription;

    __weak IBOutlet UIButton *btnPrescriptionImage;
    __weak IBOutlet UILabel *lblDescription;
    __weak IBOutlet UIButton *btnContinue;
    
}
@end
