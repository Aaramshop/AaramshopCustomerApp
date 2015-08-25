//
//  PrescriptionViewController.m
//  AaramShop
//
//  Created by Approutes on 04/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PrescriptionViewController.h"

@interface PrescriptionViewController ()
{
	NSDictionary *dictToSend;
    BOOL isImageCaptured;
}
@end

@implementation PrescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    imgPrescription.layer.cornerRadius = imgPrescription.frame.size.height/2;
    imgPrescription.clipsToBounds = YES;
    
    
    NSString *strText = @"Take a picture of your prescription \nto share it directly with\n";
    NSString *strFullText = [NSString stringWithFormat:@"%@%@",strText,_strStoreName];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:strFullText];
    
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRobotoRegular size:14] range:NSMakeRange(0, strText.length)];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kRobotoBold size:14] range:NSMakeRange(strText.length, _strStoreName.length)];
    
    lblDescription.attributedText = attrString;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    isImageCaptured = NO;

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




#pragma mark - UIButton Methods

-(IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



-(IBAction)actionUploadImage:(id)sender
{
    
    NSMutableArray * arrbuttonTitles = [[NSMutableArray alloc]initWithObjects:@"Camera",@"Select from Library", nil];
    
    [arrbuttonTitles addObject:@"Cancel"];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: nil destructiveButtonTitle: nil otherButtonTitles: nil];
    
    for (NSString *title in arrbuttonTitles) {
        [actionSheet addButtonWithTitle: title];
    }
    [actionSheet setCancelButtonIndex: [arrbuttonTitles count] - 1];
    
    [actionSheet showInView:self.view];
}

-(IBAction)actionContinue:(id)sender
{
    if (isImageCaptured == NO)
    {
        [Utils showAlertView:kAlertTitle message:@"Please upload image" delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    
	AppDelegate *deleg = APP_DELEGATE;
	SMChatViewController *chatView = nil;
	chatView = [deleg createChatViewByChatUserNameIfNeeded:deleg.objStoreModel.chat_username];
	chatView.chatWithUser =[NSString stringWithFormat:@"%@@%@",deleg.objStoreModel.chat_username,STRChatServerURL];
	chatView.friendNameId = deleg.objStoreModel.store_id;
	chatView.imageString = deleg.objStoreModel.store_image;
	chatView.userName = deleg.objStoreModel.store_name;
	chatView.isMediaAvailable	=	YES;
	chatView.dictMessageMedia	=	dictToSend;
	chatView.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:chatView animated:YES];

}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
            {
                UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.allowsEditing=NO;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:YES completion:^{}];
            }
            else
            {
                [Utils showAlertView:@"" message:@"Camera is not available." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
            }
        }
            break;
        case 1:
        {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing=NO;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePicker animated:YES completion:^{}];
        }
            break;
        case 2:
        {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        }
            break;
            
        default:
            // Do Nothing.........
            break;
    }
}


#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)pickerVw didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [pickerVw dismissViewControllerAnimated:YES completion:^{
		dictToSend= [NSDictionary dictionaryWithDictionary: info];
        imgPrescription.image = [UIImage scaleDownOriginalImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
        
        isImageCaptured = YES;
        
        lblUploadPicture.text = @"Change Picture";
    }];
    
}



@end
