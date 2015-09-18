//
//  PostAutoSuggestionTableViewController.h
//  SocialParty
//
//  Created by JTMD Innovations GmbH on 16/06/14.
//  Copyright (c) 2014 Chapp GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SearchUserDetailModal.h"
//#import "ChallengeNameListModal.h"

typedef enum {
    SearchTypeAdd,
    SearchTypeHash,
}SearchType;

@protocol AutoSuggestionDelegate <NSObject>
//-(void)autosuggestionSelected:(SearchUserDetailModal *)searchUserDetailModal;
//-(void)autosuggestionChallangeSelected:(ChallengeNameListModal *)challengeNameListModal;
-(void)userSelectedInfo:(NSDictionary*)aDictInfo ForSearchString:(NSString*)searchString forDictionaryKey:(NSString *)strKey;
@end


@interface PostAutoSuggestionTableViewController : UITableViewController{
    NSArray *arrFriends;
    NSArray *arrCopyFriends;
    NSInteger intPageCount;
    NSMutableArray *arrSearchInfo;
    BOOL isLoading;
    NSString *strSearchText;
    NSString *strDictionaryKey;
}
@property (nonatomic, weak) id <AutoSuggestionDelegate> delegate;
@property (nonatomic) SearchType searchType;
-(NSInteger)makeAutoSuggestionForName:(NSString*)name;
-(NSInteger)makeAutoSuggestionForChallangeName:(NSString*)name;
-(NSInteger)makeAutoSuggestionForName1:(NSString*)name;

@property (nonatomic, strong) NSString *searchString;
-(void)reloadTableViewWithData:(NSArray*)arrInfo forSearchString:(NSString*)searchString forDictionaryKey:(NSString *)strKey;

@end
