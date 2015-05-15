

#import "CustomChatView.h"


@implementation CustomChatView

@synthesize MediaType;
@synthesize isFromSelf;
@synthesize IndexPath;
@synthesize Delegate;
@synthesize ChatId;

-(id)init{
    self = [super init];
    if (self) {
        //        self.maxNumberOfImages=8;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame])
    {
        // Initialization code
            [self attachLongPressHandler];

    }
    return  self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder: aDecoder])
    {
        [self attachLongPressHandler];
        
    }
    
    return  self;
}


#pragma mark Clipboard

- (BOOL) canPerformAction: (SEL) action withSender: (id) sender
{
    if (action == NSSelectorFromString(@"doCopy:"))
    {
        return YES;
    }
    if (action == NSSelectorFromString(@"doPaste:"))
    {
        return YES;
    }
    else if (action == NSSelectorFromString(@"doForward:"))
    {
        return YES;
    }
    else if (action == NSSelectorFromString(@"doDelete:"))
    {
        return YES;
    }
    return  NO;
}

- (void) handleLongPress: (UIGestureRecognizer*) recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        if(self.Delegate && [self.Delegate conformsToProtocol:@protocol(clipBoardDelegate)] && [self.Delegate respondsToSelector:@selector(hideKeyboard)])
        {
            [ self.Delegate hideKeyboard];
        }
        [self becomeFirstResponder];
        
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"Copy" action: NSSelectorFromString(@"doCopy:")];
        
        UIMenuItem *forward = [[UIMenuItem alloc] initWithTitle:@"Forward" action:NSSelectorFromString(@"doForward:")];
        UIMenuItem *delete = [[UIMenuItem alloc] initWithTitle:@"Delete" action: NSSelectorFromString(@"doDelete:")];
        
        
        
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObjects:copy,forward,delete, nil]];
        
        [menu setTargetRect: self.frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
        
    }
}

- (BOOL) canBecomeFirstResponder
{
    return YES;
}


-(void)doCopy:(id)inSender
{
    if (self.Delegate &&  [self.Delegate conformsToProtocol: @protocol(clipBoardDelegate)] && [self.Delegate respondsToSelector:@selector(clipBoardCopyFromCell:)])
    {
        [self.Delegate clipBoardCopyFromCell: self];
    }
}

-(void)doForward:(id)inSender
{
    if (self.Delegate &&  [self.Delegate conformsToProtocol: @protocol(clipBoardDelegate)] && [self.Delegate respondsToSelector:@selector(clipBoardForwardFromCell:)])
    {
        [self.Delegate clipBoardForwardFromCell:self];
    }
}

-(void)doDelete:(id)inSender
{
    if (self.Delegate &&  [self.Delegate conformsToProtocol: @protocol(clipBoardDelegate)] && [self.Delegate respondsToSelector:@selector(clipBoardDeleteFromCell:)])
    {
        [self.Delegate clipBoardDeleteFromCell: self];
    }
}


- (void) attachLongPressHandler
{
         
    //    [self setUserInteractionEnabled:YES];
    UILongPressGestureRecognizer *touchy = [[UILongPressGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(handleLongPress:)];
    
    touchy.minimumPressDuration = 0.3;
    
    [self addGestureRecognizer:touchy];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willHideEditMenu:) name:UIMenuControllerWillHideMenuNotification object:nil];
}

- (void) willHideEditMenu:(NSNotification*)notification
{

    [self resignFirstResponder];
}

@end
