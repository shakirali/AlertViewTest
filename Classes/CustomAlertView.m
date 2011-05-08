//
//  CustomLoadingView.m
//  HorizontalScrollView
//

#import <QuartzCore/QuartzCore.h>

#import "CustomAlertView.h"

@interface CustomAlertView ()
-(void)initTextLabel:(NSString*)text;
-(void)initView;
-(void)initActivityIndicator;
-(void)animateView;
-(void)animateViewScaleDown;
-(void)animateViewScaleUp;
-(void)drawOuterBorderWithContext:(CGContextRef)context rect:(CGRect)rect;
-(void)drawRectAndInnerBorderWithContext:(CGContextRef)context rect:(CGRect)rect;
-(void)glossPathClipWithContext:(CGContextRef)context rect:(CGRect)rect;
-(void)glossRadiusPathClipWithContext:(CGContextRef)context;
-(void)drawGlossGradientWithContext:(CGContextRef)context;
-(void)drawRoundedRectangleWithContext:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius;
@end

@implementation CustomAlertView

#define FONT_SIZE 16.0
#define VERTICAL_INSET 30.0
#define HORIZONTAL_INSET 10.0
#define TEXTLABEL_TAG 1
const CGFloat SHADOW_RADIUS = 8.0;
const CGFloat CORNER_RADIUS = 9.5;
const CGFloat GLOSS_HEIGHT = 30.0;

#pragma mark CustomAlertView class methods
+(CGColorSpaceRef)genericRGBColorSpace{
	static CGColorSpaceRef space = NULL;
	if (space == NULL)
		space = CGColorSpaceCreateDeviceRGB();
	return space;
}

+(CGColorRef)whiteColor{
	static CGColorRef white = NULL;
	if (white == NULL){
		CGFloat values[4] = { 1.0, 1.0, 1.0, 1.0};
		white = CGColorCreate([CustomAlertView genericRGBColorSpace], values);
	}
	return white;
}

+(CGColorRef)shadowColor{
	static CGColorRef shadowColor = NULL;
	if (shadowColor == NULL){
		CGFloat values[4] = { 0.0, 0.0, 0.0, 0.5};
		shadowColor = CGColorCreate([CustomAlertView genericRGBColorSpace], values);
	}
	return shadowColor;
}

+(CGColorRef)grayColor{
	static CGColorRef grayColor = NULL;
	if (grayColor == NULL){
		CGFloat values[4] = {0.41, 0.41, 0.41, 1.0}; 
		grayColor = CGColorCreate([CustomAlertView genericRGBColorSpace], values); 
	}
	return grayColor;
}

+(CGColorRef)translucentBlueColor{
	static CGColorRef translucentBlueColor = NULL;
	if (translucentBlueColor == NULL){
		CGFloat values[4] = {0.13, 0.24, 0.44, 0.8}; 
		translucentBlueColor = CGColorCreate([CustomAlertView genericRGBColorSpace], values); 
	}
	return translucentBlueColor;
}

#pragma mark CustomAlertView instance methods

-(id)initWithFrame:(CGRect)frame withText:(NSString*)text{
    self = [super initWithFrame:frame];
    if (self) {
		//loadingText = [text retain];
		self.backgroundColor = [UIColor clearColor];
		[self initTextLabel:text];
		[self initActivityIndicator];
	}
    return self;
}


-(void)initView{
	self.backgroundColor = [UIColor clearColor];
	self.hidden = YES;
}

#pragma mark DrawRect functions.
-(void)drawRect:(CGRect)rect{
	CGRect currentBounds = self.bounds;
	CGRect actualViewRect;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	actualViewRect = CGRectInset(currentBounds, 0.5, 0.5);
	CGContextSaveGState(context);
	//Draw gray border around rectangle.
	[self drawOuterBorderWithContext:context rect:actualViewRect];
	CGContextRestoreGState(context);
	//Fill Rect with thick border.	
	CGContextSaveGState(context);
	actualViewRect = CGRectInset(actualViewRect, 1.5, 1.5);
	[self drawRectAndInnerBorderWithContext:context rect:actualViewRect];
	CGContextRestoreGState(context);
	//Gloss clipping path.
	[self glossPathClipWithContext:context rect:actualViewRect];
	//Gloss radius.
	[self glossRadiusPathClipWithContext:context];
	//Draw gloss gradient.
	[self drawGlossGradientWithContext:context];
}

-(void)drawOuterBorderWithContext:(CGContextRef)context rect:(CGRect)rect{
	CGContextSetLineWidth(context, 1.0);
	CGContextSetStrokeColorWithColor(context, [CustomAlertView grayColor]);
	CGContextBeginPath(context);
	[self drawRoundedRectangleWithContext:context rect:rect radius:CORNER_RADIUS];
    CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathStroke);
}

-(void)drawRoundedRectangleWithContext:(CGContextRef)context rect:(CGRect)rect radius:(CGFloat)radius{
	//process only if radius is less than half of size and width.
	if (radius >= rect.size.width /2 || radius >= rect.size.height/2)
		return;
	
	CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
	
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
}

-(void)drawRectAndInnerBorderWithContext:(CGContextRef)context rect:(CGRect)rect{
	//Draw blue background color with white border.
	CGContextSetLineWidth(context, 2.0);
	CGContextSetStrokeColorWithColor(context, [CustomAlertView whiteColor]);
	CGContextSetFillColorWithColor(context, [CustomAlertView translucentBlueColor]);
	CGContextBeginPath(context);
	[self drawRoundedRectangleWithContext:context rect:rect radius:CORNER_RADIUS];
    CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFillStroke);
}


-(void)glossPathClipWithContext:(CGContextRef)context rect:(CGRect)rect{
	//Gloss clipping path.
	CGContextBeginPath(context);
    [self drawRoundedRectangleWithContext:context rect:rect radius:CORNER_RADIUS];
	CGContextClosePath(context);
	CGContextClip(context);
}

-(void)glossRadiusPathClipWithContext:(CGContextRef)context{
	CGRect currentBounds = self.bounds;
	CGFloat glossRadius = currentBounds.size.width * 2;
	CGPoint glossPoint = CGPointMake(CGRectGetMidX(currentBounds), GLOSS_HEIGHT - glossRadius);
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, glossPoint.x, glossPoint.y);
	CGContextAddArc(context, glossPoint.x, glossPoint.y, glossRadius, 0.0, M_PI, 0);
	CGContextClosePath(context);
	CGContextClip(context);
}

-(void)drawGlossGradientWithContext:(CGContextRef)context{
	CGRect currentBounds = self.bounds;
	CGGradientRef glossGradient;
	CGFloat locations[2] = {0.0, 1.0};
	CGFloat components[8] = { 1.0, 1.0, 1.0, 0.65, //start color
		1.0, 1.0, 1.0, 0.06 //end color
	};
	glossGradient = CGGradientCreateWithColorComponents([CustomAlertView genericRGBColorSpace], components, locations, 2);
	CGPoint topCentre = CGPointMake(CGRectGetMidX(currentBounds), 0.0f);
	CGPoint midCentre = CGPointMake(CGRectGetMidX(currentBounds), GLOSS_HEIGHT);
	CGContextDrawLinearGradient(context, glossGradient, topCentre, midCentre, 0);
	CGGradientRelease(glossGradient);
}

#pragma mark Show
-(void)show{
	self.transform = CGAffineTransformMakeScale(0.01, 0.01);
	[self animateView];
}

#pragma mark init functions.
-(void)initTextLabel:(NSString*)text{
	CGSize viewSize = self.bounds.size;
	//determine font size.
	UIFont* font = [UIFont boldSystemFontOfSize:FONT_SIZE];
	CGSize size = [text sizeWithFont:font];
	//create label
	textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,0.0, size.width, size.height)];
	textLabel.backgroundColor = [UIColor clearColor];
	textLabel.textColor = [UIColor whiteColor];
	textLabel.text = text;
	textLabel.font = font;
	textLabel.contentMode = UIViewContentModeCenter;
	//adjust label location.
	CGRect frame = textLabel.frame;
	frame.origin.x = fmaxf((viewSize.width - frame.size.width) / 2, HORIZONTAL_INSET);
	frame.origin.y = VERTICAL_INSET;
	textLabel.frame = frame;
	[self addSubview:textLabel];
}

-(void)initActivityIndicator{
	CGSize viewSize = self.bounds.size;
	activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	CGSize activityViewsize = [activityView sizeThatFits:CGSizeMake(0.0, 0.0)];
	//adjust activityview location.
	CGRect frame = activityView.frame;
	frame.origin.x = (viewSize.width - activityViewsize.width)/2;
	frame.origin.y = viewSize.height - activityViewsize.height - VERTICAL_INSET;
	frame.size = activityViewsize;
	activityView.frame = frame;
	[activityView startAnimating];
	[self addSubview:activityView];
}

- (void)dealloc {
	[activityView release];
	[textLabel release];
	[super dealloc];
}

#pragma mark animate functions.
-(void)animateView{
	[UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationCurveEaseInOut
					 animations:^{self.transform = CGAffineTransformMakeScale(1.2, 1.2);} 
					 completion:^(BOOL finished){[self animateViewScaleDown];}];
}

-(void)animateViewScaleDown{
	[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut
					 animations:^{self.transform = CGAffineTransformMakeScale(0.9, 0.9);} 
					 completion:^(BOOL finished){ [self animateViewScaleUp];}];
}

-(void)animateViewScaleUp{
	[UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationCurveEaseInOut
					 animations:^{self.transform = CGAffineTransformMakeScale(1.0, 1.0);} 
					 completion:^(BOOL finished){ }];
}


@end
