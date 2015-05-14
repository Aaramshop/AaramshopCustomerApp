#import <MapKit/MapKit.h>

@interface DPAnnotationView : MKAnnotationView

@property (nonatomic, assign) MKMapView *mapView;
+ (id)annotationViewWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier mapView:(MKMapView *)mapView;
@end