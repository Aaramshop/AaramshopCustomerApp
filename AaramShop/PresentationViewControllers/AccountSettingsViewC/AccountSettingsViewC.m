//
//  AccountSettingsViewC.m
//  AaramShop
//
//  Created by Approutes on 5/12/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "AccountSettingsViewC.h"

@interface AccountSettingsViewC ()
{
	UITapGestureRecognizer *gestureRecognizer;
}
@end

@implementation AccountSettingsViewC

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	[self setNavigationBar];
	strName	=	[[NSUserDefaults standardUserDefaults] objectForKey:kFullname];
	strEmailAddress	=	@"";
	tblView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tblView.frame.size.width, 0.01f)];
	aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc] init];
	aaramShop_ConnectionManager.delegate = self;
	gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[tblView addGestureRecognizer:gestureRecognizer];
	
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
	backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	backBtn.bounds = CGRectMake( -10, 0, 30, 30);
	
	[backBtn setImage:imgBack forState:UIControlStateNormal];
	[backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
	
	NSArray *arrBtnsLeft = [[NSArray alloc]initWithObjects:barBtnBack, nil];
	self.navigationItem.leftBarButtonItems = arrBtnsLeft;
	
	UIImage *imgDone = [UIImage imageNamed:@"doneBtn"];
	doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
-(BOOL)isValid
{
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
	if (![strEmailAddress isEqualToString:@""]) {
		BOOL b = [emailTest evaluateWithObject:strEmailAddress];
		if (b == NO)
		{
			[Utils showAlertView:kAlertTitle message:@"Email is not in valid format" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			return NO;
		}
	}
	
	if(strName.length == 0)
	{
		[Utils showAlertView:kAlertTitle message:@"Please enter full name." delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return NO;
	}
	return YES;
}
- (void)btnDoneClicked
{
	[self hideKeyboard];
	if ([self isValid]) {
		
		
		[doneBtn setEnabled:NO];
		[backBtn setEnabled:NO];
		[AppManager startStatusbarActivityIndicatorWithUserInterfaceInteractionEnabled:YES];
		NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
		[dict setObject:[[NSUserDefaults standardUserDefaults] valueForKey:kUserId] forKey:kUserId];
		[dict setObject:strEmailAddress forKey:kEmail];
		[dict setObject:strName forKey:kFullname];
		[self performSelector:@selector(callWebserviceToUpdateInfo:) withObject:dict];
	}
}

#pragma mark - Call Webservice To Change Password
- (void)callWebserviceToUpdateInfo:(NSMutableDictionary *)aDict
{
	if (![Utils isInternetAvailable])
	{
		[doneBtn setEnabled:YES];
		[backBtn setEnabled:YES];
		[AppManager stopStatusbarActivityIndicator];
		[Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		return;
	}
	[aaramShop_ConnectionManager getDataForFunction:kURLUpdateUsers withInput:aDict withCurrentTask:TASK_TO_UPDATE_USER Delegate:self andMultipartData:imageData withMediaKey:@"image"];
}

- (void)responseReceived:(id)responseObject
{
	[doneBtn setEnabled:YES];
	[backBtn setEnabled:YES];
	[AppManager stopStatusbarActivityIndicator];
	if (aaramShop_ConnectionManager.currentTask == TASK_TO_UPDATE_USER)
	{
		if([[responseObject objectForKey:kstatus] intValue] == 1)
		{
			

			[[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:kFullname] forKey:kFullname];
			[[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:kEmail] forKey:kEmail];
			
			[[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:@"image"] forKey:kProfileImage];
			[[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:kImage_url_100] forKey:kImage_url_100];
			[[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:kImage_url_320] forKey:kImage_url_320];
			[[NSUserDefaults standardUserDefaults] setObject:[responseObject objectForKey:kImage_url_640] forKey:kImage_url_640];
			
			
			
//			[tblView reloadData];
			
		}
		else
		{
			[Utils showAlertView:kAlertTitle message:[responseObject objectForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
		}
	}
}
- (void)didFailWithError:(NSError *)error
{
	[doneBtn setEnabled:YES];
	[backBtn setEnabled:YES];
	[AppManager stopStatusbarActivityIndicator];
	[aaramShop_ConnectionManager failureBlockCalled:error];
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
					
					UserContactTableCell *cell =[self createCell:cellIdentifier];
					cell.indexPath=indexPath;
					cell.delegateFetchValue = self;
					
					cell.txtEmail.placeholder = @"Enter your full name";
					cell.txtEmail.textColor = [UIColor colorWithRed:83/255.0f green:83/255.0f blue:83/255.0f alpha:1.0f];
					cell.txtEmail.text = strName;
					[cell.lblDetail setHidden:YES];
					[cell.txtEmail setHidden:NO];
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
					
					UserContactTableCell *cell =[self createCell:cellIdentifier];
					cell.indexPath=indexPath;
					cell.delegateFetchValue = self;
					cell.txtEmail.placeholder = @"Add Email Address";
					
					cell.txtEmail.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
					cell.txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
					[cell.txtEmail setHidden:NO];
					[cell.lblDetail setHidden:YES];
					
					tableCell = cell;
				}
					break;
				case 1:
				{
					static NSString *cellIdentifier = @"ChangeCell";
					
					UserContactTableCell *cell =[self createCell:cellIdentifier];
					
					cell.indexPath=indexPath;
					[cell.lblDetail setHidden:NO];
					cell.lblDetail.text = @"********";
					[cell.txtEmail setHidden:YES];
					cell.lblChangePass.text = @"Change Password";
					[gestureRecognizer setCancelsTouchesInView:NO];
					
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
-(UserContactTableCell*)createCell:(NSString*)cellIdentifier{
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
		UIImage *scaledImage = [UIImage scaleDownOriginalImage:[info objectForKey:@"UIImagePickerControllerEditedImage"] ProportionateTo:480];
		imageData = [NSMutableData dataWithData:UIImageJPEGRepresentation(scaledImage, 1.0)];
		
	}];
}

- (void)EndEditingInsideTable:(UITextField *)textField{
	
	id superview = [textField superview];
	while (![superview isKindOfClass:[UITableViewCell class]] && superview != nil) {
		superview = [superview superview];
	}
	
	if(superview != nil){
		UITableViewCell *cell = (UITableViewCell *)superview;
		NSIndexPath *idPath = [tblView indexPathForCell:cell];
		if(idPath.section == 0){
			switch (idPath.row) {
				case 0:{
					
					strName = [textField text];
					
				}
					
					break;
				default:
					break;
			}
		}
		else if (idPath.section == 1)
		{
			switch (idPath.row) {
				case 0:
				{
					strEmailAddress = [textField text];
				}
					break;
					
				default:
					break;
			}
		}
	}
}

@end
