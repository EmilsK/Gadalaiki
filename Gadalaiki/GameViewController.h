//
//  GameViewController.h
//  Gadalaiki
//
//  Created by Emils Kraucis.
//  Copyright (c) 2013 Emils Kraucis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DroppableView.h"

@interface GameViewController : UIViewController <DroppableViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *dropTarget1; //Ziemas mērķis
@property (nonatomic, strong) IBOutlet UIView *dropTarget2; //Pavasaria mērķis
@property (nonatomic, strong) IBOutlet UIView *dropTarget3; //Vasaras mērķis
@property (nonatomic, strong) IBOutlet UIView *dropTarget4; //Rudens mērķis
@property (nonatomic, strong) IBOutlet UIView *bottomView; //apakšējā līnija
@property (nonatomic, strong) NSMutableDictionary *imageNames; //bilžu nosaukumi
@property (nonatomic, strong) NSMutableDictionary *levelInfo; //Informācija par līmeni
@property (nonatomic, strong) NSMutableArray *gamePieces; // iesauc Kārti
@property (nonatomic, assign) CGPoint lastPosition; //iepriekšējās pozīcijas saglabāšana
@property (nonatomic, assign) NSInteger points; // punktu skaitīšana
@property (strong, nonatomic) IBOutlet UILabel *pointsToScreen; // punktu izvadīša uz ekrāna
@property (strong, nonatomic) IBOutlet UIButton *check; // pašpārbaudes darbība
@property (strong, nonatomic) IBOutlet UIButton *nextTask; // pāriešana uz nākošo uzdevumu pēc tā izpildes
@property (nonatomic, assign) int l; //mainīgais kas nosaka kurā līmenī atrdodies

- (id)initWithLevel:(int)level; // funkcija kāršu nolasīšanai no attiecīga plist faila

@end
