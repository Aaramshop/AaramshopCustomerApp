

#import <UIKit/UIKit.h>

typedef enum
{
    eTableLoadMoreStateNone = 0,
    eTableLoadMoreStateLoading ,
    eTableLoadMoreStateLoaded
}eTableLoadMoreState;

@protocol TableLoadMoreDelegate <NSObject>

@optional
-(void)tableLoadMore:(id)inCellView;

@end


@interface ChatFirstRowCell : UITableViewCell
{
	
}
@property (nonatomic, assign)  eTableLoadMoreState  loadMoreState;

@property (nonatomic, retain)  UIButton      *BtnLoadMoreItem;
@property (nonatomic,assign) BOOL isShownLoadMore;

@property (nonatomic, retain)  UIActivityIndicatorView *ActivityIndicator;
@property (nonatomic, retain) id <TableLoadMoreDelegate> Delegate;
-(IBAction)clickLoadMore:(id)inSender;
-(void)hideAndShowLoadMore:(BOOL)inBool;


@end

