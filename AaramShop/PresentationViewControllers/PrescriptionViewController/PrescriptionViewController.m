//
//  PrescriptionViewController.m
//  AaramShop
//
//  Created by Approutes on 04/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "PrescriptionViewController.h"

@interface PrescriptionViewController ()

@end

@implementation PrescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if ([[UIScreen mainScreen]bounds].size.height>480)
//    {
//        imgBackground.image = [UIImage imageNamed:@""];
//    }
//    else
//    {
//        imgBackground.image = [UIImage imageNamed:@""];
//    }
    
    
    
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
                imagePicker.allowsEditing=YES;
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
            imagePicker.allowsEditing=YES;
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
        
        imgPrescription.image = [UIImage scaleDownOriginalImage:[info objectForKey:@"UIImagePickerControllerEditedImage"]];
        lblUploadPicture.text = @"Change Picture";
    }];
    
}



@end
