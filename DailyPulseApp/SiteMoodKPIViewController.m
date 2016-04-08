//
//  SiteMoodKPIViewController.m
//

#import "SiteMoodKPIViewController.h"
#import "DataManager.h"
#import "Common.h"

#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

@interface SiteMoodKPIViewController ()
- (void)appWillEnterForeground;
- (void)drawCircleWithGreen:(NSInteger)greenPerc;
- (void)removeDrawings;
@end

@implementation SiteMoodKPIViewController

- (void)setInitData:(RequestEnum)request {
    self.currentRequest = request;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [DataManager instance];
    self.apiManager = [[APIManager alloc] initWithDelegate:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(appWillEnterForeground)
                                                name:UIApplicationWillEnterForegroundNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(appWillEnterForeground)
                                                name:FirstLoginPerformedNotification
                                              object:nil];
    
    if (self.currentRequest == REQ_OFFICE_MOOD)
        self.siteLabel.text = NSLocalizedString(@"In-Site", @"SiteMoodKPIViewController");
    else
        self.siteLabel.text = NSLocalizedString(@"Off-Site", @"SiteMoodKPIViewController");
    
    self.errorLabel.text = NSLocalizedString(@"Data unavailable", @"SiteMoodKPIViewController");
    
    [self appWillEnterForeground];
}

- (void)apiManagerRequest:(RequestEnum)request success:(id)responseObject {
    if (request == self.currentRequest) {
        if (DICTIONARY_IS_VALID(responseObject)) {
            if (NUMBER_IS_VALID([responseObject objectForKey:@"green"]) &&
                NUMBER_IS_VALID([responseObject objectForKey:@"red"])) {
                self.happyLabel.text = [NSString stringWithFormat:@"%d%%", (short)[[responseObject objectForKey:@"green"] integerValue]];
                self.sadLabel.text = [NSString stringWithFormat:@"%d%%", (short)[[responseObject objectForKey:@"red"] integerValue]];
                
                self.happyImage.hidden = NO;
                self.sadImage.hidden = NO;

                [self drawCircleWithGreen:[[responseObject objectForKey:@"green"] integerValue]];
            }
        }
    }
}

- (void)apiManagerRequest:(RequestEnum)request failure:(NSError *)error {
    NSLog(@"Request %d Failure!", (int)request);
    self.errorLabel.hidden = NO;
}

- (void)drawCircleWithGreen:(NSInteger)greenPerc {
    float endAngle = greenPerc*3.6-90;
    
    CAShapeLayer *greenLayer = [CAShapeLayer layer];
    [greenLayer setPath:[[UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:85 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(endAngle) clockwise:YES] CGPath]];
    [greenLayer setStrokeColor:[[UIColor colorWithRed:60.0/255.0 green:230.0/255.0 blue:60.0/255.0 alpha:1.0] CGColor]];
    [greenLayer setFillColor:[[UIColor clearColor] CGColor]];
    greenLayer.lineWidth = 13;
    [[self.view layer] addSublayer:greenLayer];
    
    CAShapeLayer *redLayer = [CAShapeLayer layer];
    [redLayer setPath:[[UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:85 startAngle:DEGREES_TO_RADIANS(endAngle) endAngle:DEGREES_TO_RADIANS(-90) clockwise:YES] CGPath]];
    [redLayer setStrokeColor:[[UIColor colorWithRed:230.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0] CGColor]];
    [redLayer setFillColor:[[UIColor clearColor] CGColor]];
    redLayer.lineWidth = 13;
    [[self.view layer] addSublayer:redLayer];
}

- (void)removeDrawings {
    NSIndexSet *indexSet = [[self.view layer].sublayers indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop){
        return [obj isMemberOfClass:[CAShapeLayer class]];
    }];
    
    NSArray *textLayers = [[self.view layer].sublayers objectsAtIndexes:indexSet];
    for (CAShapeLayer *textLayer in textLayers) {
        [textLayer removeFromSuperlayer];
    }
}

- (void)appWillEnterForeground {
    [self removeDrawings];
    
    CAShapeLayer *grayLayer = [CAShapeLayer layer];
    [grayLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(15, 15, 170, 170)] CGPath]];
    [grayLayer setStrokeColor:[[UIColor lightGrayColor] CGColor]];
    [grayLayer setFillColor:[[UIColor clearColor] CGColor]];
    grayLayer.lineWidth = 15;
    [[self.view layer] addSublayer:grayLayer];
    
    self.happyLabel.text = @"";
    self.sadLabel.text = @"";
    self.happyImage.hidden = YES;
    self.sadImage.hidden = YES;
    self.errorLabel.hidden = YES;
    
    if (self.dataManager.data.userAlreadyLogged) {
        if (self.currentRequest == REQ_OFFICE_MOOD)
            [self.apiManager performRequest:self.currentRequest object:self.dataManager.data.officeSiteId];
        else
            [self.apiManager performRequest:self.currentRequest object:self.dataManager.data.mobileSiteId];
    }
}

@end
