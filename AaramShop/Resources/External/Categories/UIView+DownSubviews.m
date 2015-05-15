
#import "UIView+DownSubviews.h"
@implementation UIView (DownSubviews)

-(void)downSubviews:(UIView *)onview
{
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    if ([iOSVersion floatValue]>=7.0)
    {
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        
        UIView *addStatusBar = [[UIView alloc] init];
        addStatusBar = [[UIView alloc] initWithFrame:CGRectMake(0,-20,320,20)];
        addStatusBar.backgroundColor =[UIColor whiteColor];
        [onview addSubview:addStatusBar];
        
        CGRect TempRect;
        for(UIView *sub in onview.subviews)
        {
            TempRect=[sub frame];
            TempRect.origin.y+=20.0f;
            [sub setFrame:TempRect];
        }
    }
}
@end
