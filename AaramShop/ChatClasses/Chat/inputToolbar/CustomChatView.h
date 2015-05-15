

#import <UIKit/UIKit.h>

@protocol clipBoardDelegate <NSObject>

@optional
-(void)clipBoardCopyFromIndexPath:(NSIndexPath*)inIndexPath andMediaType:(NSString *)inMediaType;
-(void)clipBoardForwardFromIndexPath:(NSIndexPath*)inIndexPath andMediaType:(NSString *)inMediaType;
-(void)clipBoardDeleteFromIndexPath:(NSIndexPath*)inIndexPath andMediaType:(NSString *)inMediaType;


-(void)clipBoardCopyFromCell:(id)inCell;
-(void)clipBoardForwardFromCell:(id)inCell;
-(void)clipBoardDeleteFromCell:(id)inCell;
-(void)hideKeyboard;

@end

@interface CustomChatView : UIView
{
	UILabel      *dateLabel;
    
}

@property (nonatomic, assign)  BOOL      isFromSelf;
@property (nonatomic, retain)  NSIndexPath * IndexPath;
@property(nonatomic,retain) NSString * MediaType;
@property(nonatomic,retain) NSString * ChatId;

@property(nonatomic,retain) id <clipBoardDelegate> Delegate;


@end
