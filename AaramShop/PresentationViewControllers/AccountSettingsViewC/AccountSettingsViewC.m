//
//  AccountSettingsViewC.m
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AccountSettingsViewC.h"

@interface AccountSettingsViewC ()

@end

@implementation AccountSettingsViewC

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setNavigationBar];
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:gestureRecognizer];
}

- (void)hideKeyboard
{
	[self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}
-(void)setNavigationBar
{
	CGRect headerTitleSubtitleFrame = CGRectMake(0, 0, 150, 44);
	UIView* _headerTitleSubtitleView = [[UILabel alloc] initWithFrame:headerTitleSubtitleFrame];
	_headerTitleSubtitleView.backgroundColor = [UIColor clearColor];
	_headerTitleSubtitleView.autoresizesSubviews = NO;
	
	CGRect titleFrame = CGRectMake(0,0, 150, 44);
	UILabel* titleView = [[UILabel alloc] initWithFrame:titleFrame];
	titleView.backgroundColor = [UIColor clearColor];
	titleView.font = [UIFont fontWithName:kRobotoRegular size:15];
	titleView.textAlignment = NSTextAlignmentCenter;
	titleView.textColor = [UIColor whiteColor];
	titleView.text = @"Account Settings";
	titleView.adjustsFontSizeToFitWidth = YES;
	[_headerTitleSubtitleView addSubview:titleView];
	self.navigationItem.titleView = _headerTitleSubtitleView;
	
	UIImage *imgBack = [UIImage imageNamed:@"backBtn.png"];
	UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.bounds = CGRectMake( -10, 0, 30, 30);
	
	[backBtn setImage:imgBack forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	
	UIImage *imgDone = [UIImage imageNamed:@"doneBtn"];
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.bounds = CGRectMake( -10, 0, 50, 30);
	[doneBtn setTitle:@"Done" forState:UIControlStateNormal];
	[doneBtn.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:13.0]];
	[doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn setBackgroundImage:imgDone forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(btnDoneClicked) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnDone = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
	
	NSArray *arrBtnsRight = [[NSArray alloc]initWithObjects:barBtnDone, nil];
	self.navigationItem.rightBarButtonItems = arrBtnsRight;
	
}
- (void)btnDoneClicked
{
//	[tblView setUserInteractionEnabled:NO];
//	[self savePreferences];
}
-(void)backBtn
{
	[self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView Delegates & Data Source Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
	return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return 1;
		break;
		case 1:
			return 2;
		break;
			
			
		default:
			return 0;
		break;
	}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return 180;
		break;
			
		default:
			return 10;
			break;
	}
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	switch (section) {
  case 0:
		{
			UIView *secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 180)];
			imgUser = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 180)];
			
			[imgUser setContentMode:UIViewContentModeScaleAspectFill];
			[imgUser setClipsToBounds:YES];
			[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
			
			
			//	NSLog(@"%@",[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImageBaseUrl] ,[Utils getUserDefaultValue:kProfileImage]]);
			
			[imgUser sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kImage_url_320],[[NSUserDefaults standardUserDefaults] valueForKey:kProfileImage]]] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
				
				[AppManager stopStatusbarActivityIndicator];
			}];
			
			
			UIButton *btnUpdateImage = [UIButton buttonWithType:UIButtonTypeCustom];
			btnUpdateImage.frame = CGRectMake(-2, secView.frame.size.height-38, [[UIScreen mainScreen] bounds].size.width+4, 38+1);
			
			[btnUpdateImage addTarget:self action:@selector(showOptions) forControlEvents:UIControlEventTouchUpInside];
			
			UIImageView *imgOverlay = [[UIImageView alloc]initWithFrame:btnUpdateImage.frame];
			imgOverlay.backgroundColor = [UIColor blackColor];
			imgOverlay.alpha = 0.5;
			
			btnUpdateImage.layer.borderColor = [UIColor whiteColor].CGColor;
			btnUpdateImage.layer.borderWidth = 0.5;
			
			[btnUpdateImage setTitle:@"Change your Selfie" forState:UIControlStateNormal];
			[btnUpdateImage setImage:[UIImage imageNamed:@"profileCameraIcon"] forState:UIControlStateNormal];
			
			
			[btnUpdateImage setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
			[btnUpdateImage setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
			
			[btnUpdateImage.titleLabel setFont:[UIFont fontWithName:kRobotoRegular size:14]];
			
			
			[secView addSubview:imgUser];
			[secView addSubview:imgOverlay];
			[secView addSubview:btnUpdateImage];
			
			
			return secView;
		}
			break;
			
  default:
			break;
	}
	return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *tableCell = nil;
	switch (indexPath.section) {
		case eUserInfo:
		{
			switch (indexPath.row) {
				case 0:
				{
					
					static NSString *cellIdentifier = @"FirstCell";
					
					UserContactTableCell *cell =[self createCellCreate:cellIdentifier];
					

					cell.indexPath=indexPath;
					cell.txtEmail.placeholder = @"Enter your full name";
					cell.txtEmail.textColor = [UIColor colorWithRed:83/255.0f green:83/255.0f blue:83/255.0f alpha:1.0f];
					cell.txtEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:kFullname];
					
					tableCell = cell;
				}
					break;
				
				default:
					break;
			}
		}
			break;
		case eUserContact:
		{
			switch (indexPath.row) {
				case 0:
				{
					static NSString *cellIdentifier = @"EmailCell";
					
					UserContactTableCell *cell =[self createCellCreate:cellIdentifier];
					

					cell.indexPath=indexPath;
					cell.txtEmail.placeholder = @"Add Email Address";
					cell.txtEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
					tableCell = cell;
				}
					break;
				case 1:
				{
					static NSString *cellIdentifier = @"ChangeCell";
					
					UserContactTableCell *cell =[self createCellCreate:cellIdentifier];
					

					cell.indexPath=indexPath;
					cell.txtEmail.text = @"********";
//					cell.txtEmail.userInteractionEnabled = NO;
					cell.lblChangePass.text = @"Change Password";
					tableCell = cell;
				}
					break;
				default:
					break;
			}
		}
			break;
		default:
			break;
	}
	return tableCell;
}
#pragma mark - Calling Cell
-(UserContactTableCell*)createCellCreate:(NSString*)cellIdentifier{
	UserContactTableCell *cell = (UserContactTableCell *)[tblView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil) {
		cell = [[UserContactTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tblView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.section) {
		case 0:
		{
			switch (indexPath.row) {
				case 0:
				{
					
				}
					break;
				case 1:
				{
					
				}
					break;
				default:
					break;
			}
		}
			break;
		case 1:
			switch (indexPath.row) {
				case 1:
				{
					ChangePasswordViewController *changePassVwController = (ChangePasswordViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePasswordView"];
					
					[self.navigationController pushViewController:changePassVwController animated:YES];
				}
					break;
					
				default:
					break;
			}
			break;
			
		default:
			break;
	}
}

-(void)showOptions
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	// Picking Image from Camera/ Library
	[picker dismissViewControllerAnimated:YES completion:^{
		
		imgUser.image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
		//myImagePickerController.allowsEditing=YES;
		
		UIImage *scaledImage = [UIImage scaleDownOriginalImage:[info objectForKey:@"UIImagePickerControllerEditedImage"] ProportionateTo:568];
		
		imageData = [NSMutableData dataWithData:UIImageJPEGRepresentation(scaledImage, 1.0)];
//		[self callWebserviceToUpdateProfileImage];
		
	}];
}
@end
