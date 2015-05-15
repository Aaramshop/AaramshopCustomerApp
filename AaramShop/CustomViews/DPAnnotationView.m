#import "DPAnnotationView.h"

NSString *const DPAnnotationViewDidFinishDrag = @"DPAnnotationViewDidFinishDrag";
NSString *const DPAnnotationViewKey = @"DPAnnotationView";

// Estimate a finger size
// This is the amount of pixels I consider
// that the finger will block when the user
// is dragging the pin.
// We will use this to lift the pin even higher during dragging

#define kFingerSize 20.0

@interface DPAnnotationView()
@property (nonatomic) CGPoint fingerPoint;
@end

@implementation DPAnnotationView
@synthesize dragState, fingerPoint, mapView;

+ (id)annotationViewWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView {
    
    // iOS 3.2 will respond to isDraggable property, so use systemVersion to do the check. Thanks to Erich Wood (@erichwood) for the report.
    BOOL draggingSupport = ([[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] != NSOrderedAscending);
    
    if (draggingSupport) {
        MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
        [annotationView performSelector:NSSelectorFromString(@"setDraggable:") withObject:[NSNumber numberWithBool:YES]];
        annotationView.canShowCallout = NO;
        return [annotationView autorelease];
    }
    
    return [[[self alloc] initWithAnnotation_:annotation reuseIdentifier:reuseIdentifier mapView:mapView] autorelease];
}

- (id)initWithAnnotation_:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView {
    
    if ((self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])) {
        self.image = [UIImage imageNamed:@"mapPinGreen.png"];
        self.centerOffset = CGPointMake(8, -14);
        self.calloutOffset = CGPointMake(-8, 0);
        self.canShowCallout = NO;
        
        self.mapView = mapView;
    }
    
    return self;
}

- (void)setDragState:(MKAnnotationViewDragState)newDragState animated:(BOOL)animated
{
    if(mapView){
        id<MKMapViewDelegate> mapDelegate = (id<MKMapViewDelegate>)mapView.delegate;
        [mapDelegate mapView:mapView annotationView:self didChangeDragState:newDragState fromOldState:dragState];
    }

    // Calculate how much to life the pin, so that it's over the finger, no under.
    CGFloat liftValue = -(fingerPoint.y - self.frame.size.height - kFingerSize);

    if (newDragState == MKAnnotationViewDragStateStarting)
    {
        CGPoint endPoint = CGPointMake(self.center.x,self.center.y-liftValue);
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.center = endPoint;
                         }
                         completion:^(BOOL finished){
                             dragState = MKAnnotationViewDragStateDragging;
                         }];
        
    }
    else if (newDragState == MKAnnotationViewDragStateEnding)
    {
        // lift the pin again, and drop it to current placement with faster animation.
        
        __block CGPoint endPoint = CGPointMake(self.center.x,self.center.y-liftValue);
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.center = endPoint;
                         }
                         completion:^(BOOL finished){
                             endPoint = CGPointMake(self.center.x,self.center.y+liftValue);
                             [UIView animateWithDuration:0.1
                                              animations:^{
                                                  self.center = endPoint;
                                              }
                                              completion:^(BOOL finished){
                                                  dragState = MKAnnotationViewDragStateNone;
                                                  if(!mapView)
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:DPAnnotationViewDidFinishDrag object:nil userInfo:[NSDictionary dictionaryWithObject:self.annotation forKey:DPAnnotationViewKey]];
                                              }];
                         }];
    }
    else if (newDragState == MKAnnotationViewDragStateCanceling)
    {
        // drop the pin and set the state to none
        
        CGPoint endPoint = CGPointMake(self.center.x,self.center.y+liftValue);
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.center = endPoint;
                         }
                         completion:^(BOOL finished){
                             dragState = MKAnnotationViewDragStateNone;
                         }];
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    // When the user touches the view, we need his point so we can calculate by how 
    // much we should life the annotation, this is so that we don't hide any part of
    // the pin when the finger is down.

    fingerPoint = point;
    return [super hitTest:point withEvent:event];
}

@end