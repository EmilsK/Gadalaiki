//
//  DroppableView.m
//  DroppableView


#import "DroppableView.h"


#define DROPPABLEVIEW_ANIMATION_DURATION 0.33

@interface DroppableView ()
@property (nonatomic, weak) UIView *outerView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) BOOL isDragging;
@property (nonatomic, assign) BOOL didInitalizeReturnPosition;

- (void)commonInit;

- (void)beginDrag;
- (void)dragAtPosition:(UITouch*)touch;
- (void)endDrag;

- (void)changeSuperView;
@end

@implementation DroppableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithDropTarget:(UIView*)target;
{
	self = [super init];
	if (self != nil) {
        [self commonInit];
        [self addDropTarget:target];
	}
	return self;
}

- (void)commonInit;
{
    self.shouldUpdateReturnPosition = YES;
}

#pragma mark UIResponder (skāriens)

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event //kustība sākas 
{
    [super touchesBegan:touches withEvent:event]; 
	[self beginDrag];
	[self dragAtPosition: [touches anyObject]];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event //pati kustība kustība uz..
{
    [super touchesMoved:touches withEvent:event];
    [self dragAtPosition: [touches anyObject]];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event //kustība beidzas izsauc end drag
{
    [super touchesEnded:touches withEvent:event];
	[self endDrag];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event //kustība atceļas
{
    [super touchesCancelled:touches withEvent:event];
	[self endDrag];
}

#pragma mark mērķa darbības

- (void)addDropTarget:(UIView*)target;// tiek pievienots mērķis 
{
    if (!self.dropTargets) {
        self.dropTargets = [NSMutableArray array];
    }
    
    // pievieno mērķi
    if ([target isKindOfClass:[UIView class]]) {
        [self.dropTargets addObject:target];
    }
}

- (void)removeDropTarget:(UIView*)target;
{
    [self.dropTargets removeObject:target];
}

- (void)replaceDropTargets:(NSArray*)targets;
{
    self.dropTargets = [[targets filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:[UIView class]];
    }]] mutableCopy];
}

#pragma mark vilkšanas loģika

- (void)beginDrag; //notiek vilkšana
{
    // atceras vietu
    self.isDragging = YES;
    
    // tiek vilkts
    if ([self.delegate respondsToSelector: @selector(droppableViewBeganDragging:)]) {
        [self.delegate droppableViewBeganDragging: self];
    };
	
    // atjauno pozīciju
    if (!self.didInitalizeReturnPosition || self.shouldUpdateReturnPosition) {
        self.returnPosition = self.center;
        self.didInitalizeReturnPosition = YES;
    }
	
    
	[self changeSuperView];
}


- (void)dragAtPosition:(UITouch*)touch;
{
    // aizbīdas uz jauno pozīciju
	[UIView animateWithDuration:DROPPABLEVIEW_ANIMATION_DURATION animations:^{
        self.center = [touch locationInView: self.superview];
    }];
    
    // informe delegate
    if ([self.delegate respondsToSelector: @selector(droppableViewDidMove:)]) {
        [self.delegate droppableViewDidMove:self];
    }
	
    // parbaude ar mērķi vai sakrīt
    if (self.dropTargets.count > 0) {
        for (UIView *dropTarget in self.dropTargets) {
            CGRect intersect = CGRectIntersection(self.frame, dropTarget.frame);
            BOOL didHitTarget = intersect.size.width > 10 || intersect.size.height > 10;
            
            // merķis ir sasniegts
            if (didHitTarget) {
                if (self.activeDropTarget != dropTarget)
                {
                    // informē delegate par aizešanu no vecā mērķa
                    if (self.activeDropTarget != nil) {
                        // informē delegate
                        if ([self.delegate respondsToSelector:@selector(droppableView:leftTarget:)]) {
                            [self.delegate droppableView:self leftTarget:self.activeDropTarget];
                        }
                    }
                    
                    // jauns aktīvais mērķis
                    self.activeDropTarget = dropTarget;
                    
                    // informē delegate par jaunā mērķa sasniegšanu
                    if ([self.delegate respondsToSelector:@selector(droppableView:enteredTarget:)]) {
                        [self.delegate droppableView:self enteredTarget:self.activeDropTarget];
                    }
                    return;
                }
                
                // neatrodas uz mērķā
            } else {
                if (self.activeDropTarget == dropTarget)
                {
                    // inform delegate
                    if ([self.delegate respondsToSelector:@selector(droppableView:leftTarget:)]) {
                        [self.delegate droppableView:self leftTarget:self.activeDropTarget];
                    }
                    
                    // reset active target
                    self.activeDropTarget = nil;
                    return;
                }
            }
        }
    }
}

- (void) endDrag //beidzas vilkšana
{
    // informē delegate
    if([self.delegate respondsToSelector: @selector(droppableViewEndedDragging:onTarget:)]) {
        [self.delegate droppableViewEndedDragging: self onTarget:self.activeDropTarget];
    }
	
    // Parbauda uz kā uzkrīt un vai nepieciešams sūtīt atpakaļ uz iepriekšējo poziciju
    BOOL shouldAnimateBack = YES;
    if (self.activeDropTarget != nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shouldAnimateDroppableViewBack:wasDroppedOnTarget:)]) {
            shouldAnimateBack = [self.delegate shouldAnimateDroppableViewBack:self wasDroppedOnTarget:self.activeDropTarget];
        }
    }

    // ja tiek atgriezts atpakaļ superview mainās
    if (shouldAnimateBack) {
        [self changeSuperView];
    }
    
    // atjauno stāvokli
    // kas superwiev mainās
    self.isDragging = NO;
    self.activeDropTarget = nil;
	
    // atgriež atpakaļ uz bijušo poziciju
    if (shouldAnimateBack) {
        [UIView animateWithDuration:DROPPABLEVIEW_ANIMATION_DURATION animations:^{
            self.center = self.returnPosition;
        }];
    }
}

#pragma mark superview

- (void)willMoveToSuperview:(id)newSuperview
{
    if (!self.isDragging && [newSuperview isKindOfClass: [UIScrollView class]]) {
        self.scrollView = newSuperview;
        self.outerView = self.scrollView.superview;
    }
}

- (void) changeSuperView
{
    if (!self.scrollView) {
        [self.superview bringSubviewToFront: self];
        return;
    }
    
	UIView * tmp = self.superview;
	
	[self removeFromSuperview];
	[self.outerView addSubview: self];
	
	self.outerView = tmp;
	
	// ieliek jaunajā pozīcijā
	
	CGPoint ctr = self.center;
	
	if (self.outerView == self.scrollView) {
		ctr.x += self.scrollView.frame.origin.x - self.scrollView.contentOffset.x;
		ctr.y += self.scrollView.frame.origin.y - self.scrollView.contentOffset.y;
	} else {
		ctr.x -= self.scrollView.frame.origin.x - self.scrollView.contentOffset.x;
		ctr.y -= self.scrollView.frame.origin.y - self.scrollView.contentOffset.y;
	}

	self.center = ctr;
}


@end
