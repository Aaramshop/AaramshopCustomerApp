//
//  FeedbackViewController.m
//  AaramShop
//
//  Created by Approutes on 05/08/15.
//  Copyright (c) 2015 Approutes. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    viewRating.layer.cornerRadius = 3.0;
    viewRating.clipsToBounds = YES;
    
    imgStore.layer.cornerRadius = imgStore.frame.size.height/2;
    imgStore.clipsToBounds = YES;
    
    [self initData];
    
    btnOK.enabled = NO;
    rating = 0;
    
    aaramShop_ConnectionManager = [[AaramShop_ConnectionManager alloc]init];
    aaramShop_ConnectionManager.delegate=self;
    
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


-(void)initData
{
    
    imgStore.image = [UIImage imageNamed:@"shoppingListDefaultImage.png"];
    
    [imgStore sd_setImageWithURL:[NSURL URLWithString:_strStore_image] placeholderImage:[UIImage imageNamed:@"shoppingListDefaultImage.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    
    lblStoreName.text = _strStore_name;
    lblDescText.text = [NSString stringWithFormat:@"Rate your experience with \n%@",_strStore_name];

    
}


#pragma mark - UIButto Methods

-(IBAction)actionClose:(id)sender
{
    [self removeFeedBackScreen];
}

-(IBAction)actionRating:(UIButton*)sender
{
    btnOK.enabled = YES;
    
    btnRating1.selected = NO;
    btnRating2.selected = NO;
    btnRating3.selected = NO;
    btnRating4.selected = NO;
    btnRating5.selected = NO;
    
    
    switch (sender.tag)
    {
        case 1:
        {
            btnRating1.selected = YES;
            rating = 1;
        }
            break;
        case 2:
        {
            btnRating1.selected = YES;
            btnRating2.selected = YES;
            rating = 2;
        }
            break;
        case 3:
        {
            btnRating1.selected = YES;
            btnRating2.selected = YES;
            btnRating3.selected = YES;
            rating = 3;

        }
            break;
        case 4:
        {
            btnRating1.selected = YES;
            btnRating2.selected = YES;
            btnRating3.selected = YES;
            btnRating4.selected = YES;
            rating = 4;

        }
            break;
        case 5:
        {
            btnRating1.selected = YES;
            btnRating2.selected = YES;
            btnRating3.selected = YES;
            btnRating4.selected = YES;
            btnRating5.selected = YES;
            rating = 5;


        }
            break;
            
        default:
            break;
    }
    
}

-(IBAction)actionOK:(id)sender
{
    txtView.text = [txtView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self callWebserviceToSendReview];
    
    
}

-(IBAction)actionCancel:(id)sender
{
    [self removeFeedBackScreen];
}



#pragma mark - TextView Delegates

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    lblPlaceHolder.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length == 0){
        lblPlaceHolder.hidden = NO;
    }
    else
    {
        lblPlaceHolder.hidden = YES;
    }
}


#pragma mark - Call Webservice To Send Review
-(void)callWebserviceToSendReview
{
    NSMutableDictionary *dict = [Utils setPredefindValueForWebservice];
    
    [dict setObject:_strStore_Id forKey:kStore_id];
    [dict setObject:[NSString stringWithFormat:@"%d",rating] forKey:@"rating"];
    [dict setObject:txtView.text forKey:@"comment"];
    
    
    if (![Utils isInternetAvailable])
    {
        [AppManager stopStatusbarActivityIndicator];
        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        return;
    }
    [aaramShop_ConnectionManager getDataForFunction:kURLUserReview withInput:dict withCurrentTask:TASK_TO_SEND_USER_REVIEW andDelegate:self];
}


- (void)responseReceived:(id)responseObject
{
    [AppManager stopStatusbarActivityIndicator];
    if(aaramShop_ConnectionManager.currentTask == TASK_TO_SEND_USER_REVIEW)
    {
        if([[responseObject objectForKey:kstatus] intValue] == 1)
        {
            [self removeFeedBackScreen];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:[responseObject valueForKey:kMessage] delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
        }
    }
}

- (void)didFailWithError:(NSError *)error
{
    [AppManager stopStatusbarActivityIndicator];
    [aaramShop_ConnectionManager failureBlockCalled:error];
}



-(void)removeFeedBackScreen
{
    if (self.feedbackCompletion)
    {
        self.feedbackCompletion();
    }
    
    [self.view removeFromSuperview];
}

@end
