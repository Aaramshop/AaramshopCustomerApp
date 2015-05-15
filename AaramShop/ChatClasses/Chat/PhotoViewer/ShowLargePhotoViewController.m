//
//  ShowLargePhotoViewController.m
//  SocialParty
//
//  Created by APPROUTES on 06/03/14.
//  Copyright (c) 2014 AppRoutes. All rights reserved.
//

#import "ShowLargePhotoViewController.h"
//#import "NewSelectedAlbumViewController.h"
#import "AppDelegate.h"
@interface ShowLargePhotoViewController ()
{
    BOOL hide;
}
@end

@implementation ShowLargePhotoViewController
@synthesize pageViewController,arrayImages;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        hide = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (IBAction)btnBackClicked:(id)sender {
    self.navigationController.navigationBarHidden = NO;
    [[AppManager sharedManager].arrImages removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setInitializePageViewController{
    
    PhotoLargeViewController *pageZero = [[PhotoLargeViewController alloc ]initWithPageIndex:_intArrayIndex  andTotalCount:_strTotalPhotoCount];
    
    if (pageZero != nil)
    {
        // assign the first page to the pageViewController (our rootViewController)
        pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:Nil];
        pageViewController.dataSource = self;
        pageViewController.delegate=self;
        [pageViewController setViewControllers:@[pageZero] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    }
    [pageViewController.view setBackgroundColor:[UIColor blackColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.strTotalPhotoCount) {
        self.strTotalPhotoCount = @"";
    }
    NSInteger index = self.intArrayIndex+1;
     NSString *currentInd=[NSString stringWithFormat:@"%d",index];
    if(index<10)
    {
        currentInd = [NSString stringWithFormat:@"0%d",index];
    }
    NSString *count = [NSString stringWithFormat:@"%d",[self.arrayImages count]];
    if([self.strTotalPhotoCount intValue]<10)
    {
        count = [NSString stringWithFormat:@"0%@",self.strTotalPhotoCount];
        [self.lblCounter setText:[NSString stringWithFormat:@"%@/%@",currentInd,count]];
    }
    else
    {
        [self.lblCounter setText:[NSString stringWithFormat:@"%@/%@",currentInd,self.strTotalPhotoCount]];
    }
    
    
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:pageViewController.view atIndex:0];
    [pageViewController didMoveToParentViewController:self];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fadeInFadeOut:)];
    [pageViewController.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}
// Priyanka start

-(void)GetResponse:(NSNotification *)notification
{
    NSDictionary *tempdict=[notification  userInfo];
    
    NSArray *arrtemp=[tempdict objectForKey:@"Data"];
    NSLog(@"value=%@",arrayImages);
    NSLog(@"value=%@",arrtemp);
    self.intArrayIndex=+1;
//    arrayImages=nil;
    
    NSMutableSet *set1 = [[NSMutableSet alloc] initWithArray: arrayImages];
    NSMutableSet *set2 = [[NSMutableSet alloc] initWithArray: arrtemp];
    [set2 minusSet: set1];
    
    NSLog(@"value=%@",arrayImages);
    NSMutableArray *aTemp = [[NSMutableArray alloc] initWithArray: arrayImages];
    
    [aTemp addObjectsFromArray: set2.allObjects];
    arrayImages = nil;
     arrayImages=[NSArray arrayWithArray:aTemp];

//    [[AppManager sharedManager].arrImages removeAllObjects];
    [[AppManager sharedManager].arrImages addObjectsFromArray: set2.allObjects];


    PhotoLargeViewController *pageZero = [[PhotoLargeViewController alloc ]initWithPageIndex: self.intArrayIndex  andTotalCount:_strTotalPhotoCount];
    
    if (pageZero != nil)
    {
        // assign the first page to the pageViewController (our rootViewController)
        pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:1 navigationOrientation:0 options:Nil];
        pageViewController.dataSource = self;
        pageViewController.delegate=self;
        [pageViewController setViewControllers:@[pageZero] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    }
    [pageViewController.view setBackgroundColor:[UIColor blackColor]];

}

// Priyanka end



#pragma mark
#pragma mark PageViewController Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(PhotoLargeViewController *)vc
{
    
    //Return next Index
    NSUInteger index = vc.pageIndex;

    PhotoLargeViewController *photo=[[PhotoLargeViewController alloc]initWithPageIndex:index-1 andTotalCount:_strTotalPhotoCount];
    
    return photo;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(PhotoLargeViewController *)vc
{

    if (self.arrayImages.count == vc.pageIndex + 1 && self.arrayImages.count + 1 < [self.strTotalPhotoCount integerValue]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadMorePhotosOfAlbum" object:nil];
    }

    //Return next Index
    NSUInteger index = vc.pageIndex;
    PhotoLargeViewController *photo=[[PhotoLargeViewController alloc]initWithPageIndex:index+1  andTotalCount:_strTotalPhotoCount];
    return photo;
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    NSLog(@"Current IIIINd");
}

- (void)pageViewController:(UIPageViewController *)pvc didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed)
    {
        return;
    }
    
    NSUInteger currentIndex = [[self.pageViewController.viewControllers lastObject] pageIndex];
   _intArrayIndex=currentIndex;
    currentIndex=currentIndex+1;
   
    NSString *currentInd=[NSString stringWithFormat:@"%d",currentIndex];
    if(currentIndex<10)
    {
        currentInd = [NSString stringWithFormat:@"0%d",currentIndex];
    }
    NSString *count = [NSString stringWithFormat:@"%d",[self.arrayImages count]];
    if([self.strTotalPhotoCount intValue]<10)
    {
        count = [NSString stringWithFormat:@"0%@",self.strTotalPhotoCount];
    }
    else
    {
        count = self.strTotalPhotoCount;
    }
    [self.lblCounter setText:[NSString stringWithFormat:@"%@/%@",currentInd,count]];
    NSLog(@"Current IIIINdex :%d",currentIndex);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"true");
}// any offset changes

-(void)UpDateImageViews{
    
    
    
    for (id obj in pageViewController.viewControllers) {
        PhotoLargeViewController *object=(PhotoLargeViewController*)obj;
        ScrollerLargeViewController *scroll=(ScrollerLargeViewController*)object.scrollView;
        
        if ((object.pageIndex < [[AppManager sharedManager].arrImages count])) {
             [scroll updateImageFromPhotoViewer:[[[AppManager sharedManager].arrImages objectAtIndex:object.pageIndex] valueForKey:@"originalCompressImage"]];
        }
        
       
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fadeInFadeOut:(UITapGestureRecognizer *)sender {
    
    if (hide == NO) {
        hide = ! hide;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.imgViewNavigation.alpha = 0;
            self.lblCounter.alpha = 0;
            self.btnBack.alpha = 0;
        } completion:nil];
        
    }else if (hide == YES){
        hide = ! hide;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        [UIView animateWithDuration:.35 delay:0 options:UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionAllowUserInteraction animations:^{
            self.imgViewNavigation.alpha = 1;
            self.lblCounter.alpha = 1;
            self.btnBack.alpha = 1;
        } completion:nil];
    }
}
@end
