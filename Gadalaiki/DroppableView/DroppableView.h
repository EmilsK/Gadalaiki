//
//  DroppableView.h
//  DroppableView



@protocol DroppableViewDelegate;

@interface DroppableView : UIView

@property (nonatomic, weak) id<DroppableViewDelegate> delegate;

@property (nonatomic, assign) CGPoint returnPosition;
@property (nonatomic, assign) BOOL shouldUpdateReturnPosition;
@property (nonatomic, weak) UIView *activeDropTarget; 
@property (nonatomic, strong) NSMutableArray *dropTargets; //mērķi
@property (nonatomic, weak) UIView *correctDropTarget; //pareizais mērķis
@property (nonatomic, weak) UIView *currentDropTarget; //esošais mērķis

- (id)initWithDropTarget:(UIView*)target;

// target managment
- (void)addDropTarget:(UIView*)target;
- (void)removeDropTarget:(UIView*)target;
- (void)replaceDropTargets:(NSArray*)targets;

@end


// DroppableViewDelegate

@protocol DroppableViewDelegate <NSObject>
@optional
// track dragging state
- (void)droppableViewBeganDragging:(DroppableView*)view;
- (void)droppableViewDidMove:(DroppableView*)view;
- (void)droppableViewEndedDragging:(DroppableView*)view onTarget:(UIView*)target;

// track target recognition
- (void)droppableView:(DroppableView*)view enteredTarget:(UIView*)target;
- (void)droppableView:(DroppableView*)view leftTarget:(UIView*)target;
- (BOOL)shouldAnimateDroppableViewBack:(DroppableView*)view wasDroppedOnTarget:(UIView*)target;
@end