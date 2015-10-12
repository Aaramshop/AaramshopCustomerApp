//
//  PostAutoSuggestionTableViewController.m
//  SocialParty
//
//  Created by JTMD Innovations GmbH on 16/06/14.
//  Copyright (c) 2014 Chapp GmbH. All rights reserved.
//


#import "PostAutoSuggestionTableViewController.h"
#import "PostAutoSuggestionCell.h"

//#import "SearchUserDetailModal.h"
//#import "ChallengeNameListModal.h"
//#import "ImageVideoInfoModal.h"
//#import "SearchChallengeNameCell.h"
@interface PostAutoSuggestionTableViewController ()

@end

@implementation PostAutoSuggestionTableViewController
@synthesize delegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrSearchInfo count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    PostAutoSuggestionCell *cell = (PostAutoSuggestionCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PostAutoSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    }
    
//    NSDictionary *searchInfo = [arrSearchInfo objectAtIndex:indexPath.row];
//    cell.lblFullName.text=[searchInfo valueForKey:strDictionaryKey];


    cell.lblFullName.text=[arrSearchInfo objectAtIndex:indexPath.row];
    
    
    
    return cell;
}
#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
//    if ([self.delegate respondsToSelector:@selector(userSelectedInfo:ForSearchString:forDictionaryKey:)]) {
//        [self.delegate userSelectedInfo:[arrSearchInfo objectAtIndex:indexPath.row] ForSearchString:_searchString forDictionaryKey:strDictionaryKey];
//    }
    
    if ([self.delegate respondsToSelector:@selector(userSelectedInfo:ForSearchString:)]) {
        [self.delegate userSelectedInfo:[arrSearchInfo objectAtIndex:indexPath.row] ForSearchString:_searchString];
    }
    
}

#pragma mark - Auto Sugegstion Methods
-(void)reloadTableViewWithData:(NSArray*)arrInfo forSearchString:(NSString*)searchString forDictionaryKey:(NSString *)strKey{
    arrSearchInfo = [NSMutableArray arrayWithArray:arrInfo];
    _searchString=searchString;
    strDictionaryKey = strKey;
    [self.tableView reloadData];
}


-(void)reloadTableViewWithData:(NSArray*)arrInfo forSearchString:(NSString*)searchString
{
    arrSearchInfo = [NSMutableArray arrayWithArray:arrInfo];
    _searchString=searchString;
    [self.tableView reloadData];
}



//-(NSInteger)makeAutoSuggestionForName1:(NSString*)name{
//
//    if ([name length]==0) {
//        return 0;
//    }
//
//    strSearchText = name;
//    intPageCount = 0;
//
//    NSMutableDictionary *dict =[Utils setPredefindValueForWebservice];
//
//    //Option,scroll-type,lastItemId..
//    [dict setObject:kgetUserChallenge forKey:kOption];
//
//    //  NSLog(@"%@",arrSearchInfo);
//    //Pull Up
//
//    NSMutableDictionary *aDic = [[NSMutableDictionary alloc] init];
//    aDic = [Utils setPredefindValueForWebservice];
//    [aDic setObject:kFriendSearch forKey:kOption];
//    [aDic setObject:[NSString stringWithFormat:@"%i",kSearchCount] forKey:kItemCount];
//    [aDic setObject:[NSString stringWithFormat:@"%ld",(long)intPageCount] forKey:kPageNumber];
//    [aDic setObject:name forKey:kSearchString];
//
//    [self callWebService:aDic];
//
//    return 1;
//}


//-(NSInteger)makeAutoSuggestionForChallangeName:(NSString*)name{
//
//    if ([name length]==0) {
//        return 0;
//    }
//
//    strSearchText = name;
//    intPageCount = 0;
//
//    NSMutableDictionary *dict =[Utils setPredefindValueForWebservice];
//
//
//
//    //Option,scroll-type,lastItemId..
//    [dict setObject:kgetUserChallenge forKey:kOption];
//
//    //  NSLog(@"%@",arrSearchInfo);
//    //Pull Up
//
//    NSMutableDictionary *aDic = [[NSMutableDictionary alloc] init];
//    aDic = [Utils setPredefindValueForWebservice];
//    [aDic setObject:kOptionSearchUserAcceptedChallenge forKey:kOption];
//    [aDic setObject:@"1" forKey:klastItemId];
//    [aDic setObject:@"1" forKey:kScrollType];
//    [aDic setObject:name forKey:kOptionSearchTxt];
//
//    [self callWebserviceForSearchChallengeName:aDic];
//
//
//    return 1;
//}



-(NSInteger)makeAutoSuggestionForName:(NSString*)name{
    if ([name length]==0) {
        return 0;
    }
    arrSearchInfo=[[NSArray alloc]initWithArray:arrCopyFriends];
    NSString *searchText = name;
    NSMutableArray *searchWordsArr = [[NSMutableArray alloc] init];
    NSString *newStr1= [searchText stringByReplacingOccurrencesOfString:@"," withString:@" "];
    NSMutableArray *tempArray = (NSMutableArray*)[newStr1 componentsSeparatedByString:@" "];
    for (NSString *str in tempArray) {
        NSString *tempStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([tempStr length])
        {
            [searchWordsArr addObject:tempStr];
        }
    }
    
    NSMutableArray *subpredicates = [[NSMutableArray alloc]init];
    for(NSString *term in searchWordsArr)
    {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"userName contains[cd] %@", term];
        [subpredicates addObject:p];
    }
    
    // //NSLog(@"all array %@",SharedAppDelegate.arrContacts);
    NSMutableArray *tempArry = [[NSMutableArray alloc] initWithArray:arrSearchInfo];
    
    NSPredicate *filter = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithArray:[tempArry filteredArrayUsingPredicate:filter]];
    //NSLog(@"finalarray is %@",finalArray);
    arrSearchInfo=[[NSMutableArray alloc]initWithArray:finalArray];
    [self.tableView reloadData];
    
    return [arrSearchInfo count];
}



#pragma mark Call Webservice--
//-(void)callWebService:(NSMutableDictionary *)aDic
//{
//    if (![Utils isInternetAvailable])
//    {
//        [Utils stopActivityIndicatorInView:self.view];
//        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//        return;
//    }
//
//    AFHTTPSessionManager *manager = [Utils InitSetUpForWebService];
//
//    [manager POST:kSeachUrl parameters:aDic success:
//     ^(NSURLSessionDataTask *task, id responseObject)
//     {
//         [self chekPullUpIndicatorState];
//
//         [Utils stopActivityIndicatorInView:self.view];
//         if ([[responseObject objectForKey:kStatus] intValue]==1)
//         {
//
//             if (!arrSearchInfo) {
//                 arrSearchInfo = [NSMutableArray array];
//             }
//
//             if (intPageCount == 0) {
//                 [arrSearchInfo removeAllObjects];
//             }
//
//             strSearchText = [strSearchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//             NSString * strResponse = [responseObject objectForKey:kSearchString];
//             strResponse = [strResponse stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//
//             if (![strSearchText isEqualToString:strResponse])
//             {
//                 return;
//             }
//             intPageCount =[[responseObject objectForKey:kPageNumber] integerValue]+1;
//
//
//             NSArray *arr =  [responseObject objectForKey:@"searchResult"];
//
//             if([arr count]>0)
//             {
//                 for (int i=0; i<[arr count];i++)
//                 {
//                     SearchUserDetailModal *searchUserDetail =[[SearchUserDetailModal alloc] init];
//                     searchUserDetail.userType = [[[arr objectAtIndex:i]objectForKey:kUserType] intValue];
//                     searchUserDetail.fullName = [[arr objectAtIndex:i]objectForKey:kFullName];
//                     searchUserDetail.userName = [[arr objectAtIndex:i]objectForKey:kUserName];
//                     searchUserDetail.profilePic= [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] valueForKey:kServerUrl],[[arr objectAtIndex:i] objectForKey:kProfilePic]];
//                     searchUserDetail.userId=[[arr objectAtIndex:i] objectForKey:kUserId];
//                     searchUserDetail.email=[[arr objectAtIndex:i] objectForKey:kEmail];
//                     searchUserDetail.isFollow=[[[arr objectAtIndex:i] objectForKey:kIsFollow] integerValue];
//                     [arrSearchInfo addObject:searchUserDetail];
//                 }
//             }
//             else
//             {
////                 [arrSearchInfo removeAllObjects]; //commented on 20 nov 2014  for jira issue - 97
////                 [self.tableView reloadData];
////                 self.tableView.hidden=YES; //commented on 20 nov 2014  for jira issue - 97
//                 [self chekPullUpIndicatorState];
//             }
//
//
//             [self.tableView reloadData];
//         }
//         else
//         {
//             [arrSearchInfo removeAllObjects];
//             [self.tableView reloadData];
//             self.tableView.hidden=YES;
//             [self chekPullUpIndicatorState];
//
//         }
//     }  failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//         [arrSearchInfo removeAllObjects];
//         [self.tableView reloadData];
//         self.tableView.hidden=YES;
//
//         [self chekPullUpIndicatorState];
//     }];
//
//}



//-(void)callWebserviceForSearchChallengeName:(NSMutableDictionary *)dict
//{
//    NSString *strSearch = [dict objectForKey:kOptionSearchTxt];
//
//    if (![Utils isInternetAvailable])
//    {
//        [self chekPullUpIndicatorState];
//
//        [Utils stopActivityIndicatorInView:self.view];
//        [Utils showAlertView:kAlertTitle message:kAlertCheckInternetConnection delegate:nil cancelButtonTitle:kAlertBtnOK otherButtonTitles:nil];
//        return;
//    }
//
//    AFHTTPSessionManager *manager = [Utils InitSetUpForWebService];
//
//    [manager POST:kChallengeURL parameters:dict success:
//     ^(NSURLSessionDataTask *task, id responseObject)
//     {
//         if ([[responseObject objectForKey:kStatus] intValue]==1)
//         {
//             [self chekPullUpIndicatorState];
//
//             if (![strSearch isEqualToString:[responseObject objectForKey:kOptionSearchTxt]])
//             {
//                 return;
//             }
//
//             NSArray *arrChallengeNameList = [responseObject objectForKey:kChallengeData];
//
//             if ([arrChallengeNameList count]>0)
//             {
//
//                 if (!arrSearchInfo)
//                 {
//                     arrSearchInfo = [[NSMutableArray alloc] init];
//                 }
//                 else{
//                     [arrSearchInfo removeAllObjects];
//                 }
//
//                 for (int i=0; i<[arrChallengeNameList count]; i++)
//                 {
//                     ChallengeNameListModal *challengeNameListModal = [[ChallengeNameListModal alloc]init];
//                     challengeNameListModal.challengeId = [[arrChallengeNameList valueForKey:kChallengeId]objectAtIndex:i];
//                     challengeNameListModal.challengeName = [Utils convertStringToNonLossyString:[[arrChallengeNameList valueForKey:kchallengeName]objectAtIndex:i]];
//
//                     challengeNameListModal.createdBy = [[arrChallengeNameList valueForKey:kCreatedBy]objectAtIndex:i];
//                     challengeNameListModal.createdById = [[arrChallengeNameList valueForKey:kCreatedById]objectAtIndex:i];
//                     challengeNameListModal.fileType = [[arrChallengeNameList valueForKey:kFileType]objectAtIndex:i];
//
//                     NSMutableArray *arrImgVideoinfo = [[NSMutableArray alloc] init];
//
//                     NSArray *arr =  [[arrChallengeNameList objectAtIndex:i] valueForKey:kFiles];
//
//                     if([arr count]>0)
//                     {
//                         for (int j=0; j<[arr count];j++)
//                         {
//                             ImageVideoInfoModal *imgVideoInfo = [[ImageVideoInfoModal alloc] init];
//                             imgVideoInfo.assetId = [[[arr objectAtIndex:j] valueForKey:kAssetId] integerValue];
//
//                             imgVideoInfo.url = [[arr objectAtIndex:j] valueForKey:kUrl];
//
//                             imgVideoInfo.challengeId = [[[arr objectAtIndex:j] valueForKey:kChallengeId] integerValue];
//
//                             [arrImgVideoinfo addObject:imgVideoInfo];
//                         }
//                         challengeNameListModal.files =arrImgVideoinfo;
//                     }
//
//                     [arrSearchInfo addObject:challengeNameListModal];
//                 }
//
//                 [self.tableView reloadData];
//             }
//         }
//         else
//         {
//             [arrSearchInfo removeAllObjects];
//             [self.tableView reloadData];
//             self.tableView.hidden=YES;
//             [self chekPullUpIndicatorState];
//
//         }
//
//     }  failure:^(NSURLSessionDataTask *task, NSError *error)
//     {
//         [arrSearchInfo removeAllObjects];
//         [self.tableView reloadData];
//         self.tableView.hidden=YES;
//         [self chekPullUpIndicatorState];
//
//     }];
//
//}


#pragma mark Check PullUp Indicator..
//-(void)chekPullUpIndicatorState
//{
//    if (isLoading==YES)
//    {
//        isLoading=NO;
//        UIActivityIndicatorView *activitIndicator=(UIActivityIndicatorView *)[self.view viewWithTag:kTagForActivityIndicator];
//        [activitIndicator stopAnimating];
//    }
//}

#pragma mark - ScrollView Delegate

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//
//    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height-33 && arrSearchInfo.count > 0 && scrollView.contentOffset.y>0){
//        if (!isLoading) {
//            isLoading=YES;
//            [self showFooterLoadMoreActivityIndicator:YES];
//
//            if (_searchType == SearchTypeAdd) {
//                //Initialize dict.
//                NSMutableDictionary *dict =[Utils setPredefindValueForWebservice];
//
//                //Option,scroll-type,lastItemId..
//                [dict setObject:kgetUserChallenge forKey:kOption];
//
//                //  NSLog(@"%@",arrSearchInfo);
//                //Pull Up
//
//                NSMutableDictionary *aDic = [[NSMutableDictionary alloc] init];
//                aDic = [Utils setPredefindValueForWebservice];
//                [aDic setObject:kFriendSearch forKey:kOption];
//                [aDic setObject:[NSString stringWithFormat:@"%i",kSearchCount] forKey:kItemCount];
//                [aDic setObject:[NSString stringWithFormat:@"%ld",(long)intPageCount] forKey:kPageNumber];
//                [aDic setObject:strSearchText forKey:kSearchString];
//
//                [self callWebService:aDic];
//
//            }
//
//            else if (_searchType == SearchTypeHash){
//
//
////                NSMutableDictionary *dic = [Utils setPredefindValueForWebservice];
////
////                [dic setObject:kOptionSearchUsers forKey:kOption];
////                [dic setObject:@"10" forKey:@"itemCount"];
////
////                //Pull Up
////
////                ChallengeNameListModal *challengeNameListModal = (ChallengeNameListModal *)[arrSearchInfo lastObject];
////
////                [dic setObject:challengeNameListModal.challengeId forKey:klastItemId];
////                [dic setObject:@"3" forKey:kScrollType];
////                [dic setObject:strSearchText forKey:kOptionSearchTxt];
////                [self callWebserviceForSearchChallengeName:dic];
//
//            }
//
//
//        }
//    }
////    if ([delegate respondsToSelector:@selector(HideKeyBoard)]) {
////        [delegate HideKeyBoard];
////    }
//
//}
//
//
//-(void)showFooterLoadMoreActivityIndicator:(BOOL)show{
//
//    UIView *view=[self.tableView viewWithTag:kTagForFooterViewTableview];
//    UIActivityIndicatorView *activity=(UIActivityIndicatorView*)[view viewWithTag:kTagForActivityIndicator];
//    if (show) {
//        [activity startAnimating];
//    }else
//        [activity stopAnimating];
//}



@end
