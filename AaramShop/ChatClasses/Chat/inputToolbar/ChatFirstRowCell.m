#import "ChatFirstRowCell.h"
#define FontSise 14.0
#define FontName @"ProximaNova-Regular"
#define RColorCode 107.0/255.0
#define GColorCode 109.0/255.0
#define BColorCode 110.0/255.0
#define AlphaTrans 1.0

@implementation ChatFirstRowCell

@synthesize ActivityIndicator;
@synthesize BtnLoadMoreItem;
@synthesize isShownLoadMore;
@synthesize Delegate;
@synthesize loadMoreState;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        // Initialization code
        
        CGRect cellFrame = self.frame;
        
        cellFrame.size.height = 30;
        CGRect rectActivity;
        
        rectActivity.size.width     = 30;
        rectActivity.size.height    = 30;
        rectActivity.origin.x       = 50;
        rectActivity.origin.y       = (cellFrame.size.height - rectActivity.size.height)/2;
        
        self.ActivityIndicator = [[UIActivityIndicatorView alloc] initWithFrame: rectActivity];
        [self.ActivityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        
        
        CGRect rectLoadMore = cellFrame;
        rectLoadMore.origin.x = 10;//rectActivity.origin.x + rectActivity.size.width;
        rectLoadMore.size.width =  300;
        self.BtnLoadMoreItem = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.BtnLoadMoreItem setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0]];
        self.BtnLoadMoreItem.layer.cornerRadius=8.0;
        self.BtnLoadMoreItem.clipsToBounds = YES;
        self.BtnLoadMoreItem.frame = rectLoadMore;
        [self.BtnLoadMoreItem setTitle:@"Load More Items" forState: UIControlStateNormal];
        
//        UIColor * color = [UIColor colorWithRed:RColorCode green:GColorCode blue:BColorCode alpha: AlphaTrans];
        
        [self.BtnLoadMoreItem setBackgroundImage:[UIImage imageNamed:@"chatLoadMessages"] forState: UIControlStateNormal];
        UIFont *aFont = [UIFont systemFontOfSize:13.0];
        self.BtnLoadMoreItem.titleLabel.font = aFont;
//        self.BtnLoadMoreItem.backgroundColor = [UIColor clearColor];
        [self.BtnLoadMoreItem setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
        [self.BtnLoadMoreItem addTarget: self action: @selector(clickLoadMore:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview: self.BtnLoadMoreItem];
        [self.contentView addSubview: self.ActivityIndicator];


    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

-(IBAction)clickLoadMore:(id)inSender
{
    if (self.Delegate && [self.Delegate conformsToProtocol:@protocol(TableLoadMoreDelegate)] && [self.Delegate respondsToSelector:@selector(tableLoadMore:)])
    {
        [self.Delegate tableLoadMore: self];
//        NSLog(@"clickLoadMore");
    }
}


-(void)hideAndShowLoadMore:(BOOL)inBool
{
    self.BtnLoadMoreItem.hidden = inBool;
    self.ActivityIndicator.hidden = inBool;
}

@end
