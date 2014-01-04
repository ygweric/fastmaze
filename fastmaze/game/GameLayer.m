//
// @author Eric Yang <ygweric@gmail.com> 
//         1/21/12
//

#import "GameLayer.h"


@interface GameLayer ()


@end

@implementation GameLayer
{
    float lastScale;
    CGPoint lastPosition;
    
    UIPinchGestureRecognizer *gestureRecognizerPin;
    UIPanGestureRecognizer *gestureRecognizerPan;
    UITapGestureRecognizer *gestureRecognizerTap;
}

@synthesize mazeGenerator = _mazeGenerator;
@synthesize playerEntity = _playerEntity;
@synthesize desireEntity=_desireEntity;
@synthesize currentStart = _currentStart;
@synthesize currentEnd = _currentEnd;
@synthesize batchNode = _batchNode;
@synthesize guiLayer=_guiLayer;
@synthesize mazeLayer=_mazeLayer;

#pragma mark -
- (id)init
{
    self = [super init];
    [self initSpriteSheetFile:@"buttons"];
    [self initSpriteSheetFile:@"game_sheet"];
    
    self.isTouchEnabled = YES;
    
    if (IS_IPHONE_5) {
        [self setBgWithFrameName:@"bg-568h@2x.jpg"];
    }else{
        [self setBgWithFrameName:@"bg.png"];
    }
    _mazeLayer=[CCLayer node];
    _mazeLayer.anchorPoint=ccp(0.5,0.5);
    [self addChild:_mazeLayer];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"walls.plist"];
    self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"walls.png"];
    [_mazeLayer addChild:_batchNode];
    self.mazeGenerator = [[[MazeGenerator alloc] initWithBatchNode:_batchNode layer:_mazeLayer] autorelease];

    
    [self regenerateMaze];
    
    gestureRecognizerPin = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchFrom:)] autorelease];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:gestureRecognizerPin];
    lastScale = 1.0f;
    gestureRecognizerPan = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanFrom:)] autorelease];
    [[[CCDirector sharedDirector] view] addGestureRecognizer:gestureRecognizerPan];
    gestureRecognizerTap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)]autorelease];
    gestureRecognizerTap.numberOfTapsRequired = 2;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:gestureRecognizerTap];
    
    return self;
}

- (void)regenerateMaze
{
    _mazeLayer.scale=1;
    [_mazeLayer removeAllChildrenWithCleanup:YES];
    [_batchNode removeAllChildrenWithCleanup:YES];
    [_mazeLayer addChild:_batchNode];
    _currentStart = nil;
    _currentEnd = nil;
    _playerEntity = nil;
    _desireEntity=nil;
    [self setPosition:ccp(0, 0)];
    [_mazeGenerator createUsingDepthFirstSearch];
    [self loadGeneratedMaze];  
}
-(void)restartGame{
    [_mazeGenerator cleanAllTrack:_playerEntity];
    _playerEntity.position=_currentStart.position;
}
-(void)normalSize{
    _mazeLayer.scale=1;
}
- (void)showMazeAnswer
{
    [_playerEntity beginMovement];
    //开始查找
    [_mazeGenerator searchUsingDepthFirstSearch:_currentStart.position endingAt:_currentEnd.position movingEntity:_playerEntity];
    _mazeGenerator.playerEntity=_playerEntity;
}
- (void)loadGeneratedMaze
{
    // determine our maze center
    CGPoint mazeCenter = ccp((_mazeGenerator.size.width)/2, (_mazeGenerator.size.height)/2);
    // find our center cell
    self.playerEntity = [Entity spriteWithFile:@"entity.png"];
    //    [_playerEntity setColor:ccc3(255, 255, 100)];
    [_playerEntity setColor:ccc3(248, 248, 173)];
    _playerEntity.scale=1.5;
    //set player position
    CGPoint rbMaze = ccp((_mazeGenerator.size.width), 0);
    MazeCell* rbCell= [_mazeGenerator cellForPosition:rbMaze];
    [_playerEntity setPosition:rbCell.position];
    [_mazeLayer addChild:_playerEntity];
    
    self.desireEntity = [Entity spriteWithFile:@"entity.png"];
    //set player position
    CGPoint ltMaze = ccp(0,(_mazeGenerator.size.height));
    MazeCell* ltCell= [_mazeGenerator cellForPosition:ltMaze];
    [_desireEntity setPosition:ltCell.position];
    [_mazeLayer addChild:_desireEntity];
    
    
    
    // determine the window center
    CGPoint winCenter = ccp(winSize.width/2, winSize.height/2);
    // determine the difference between the two
    CGPoint diff = ccpSub(winCenter, mazeCenter);
    // add the difference to our current position to center the maze
    [_mazeLayer setPosition:ccpAdd(position_, ccp(diff.x, diff.y/2))];

    
    //创建&放置start点
    if (_currentStart == nil) {
        _currentStart = [Entity spriteWithFile:@"entity.png"];
        [_currentStart setColor:ccGREEN];
        _currentStart.scale=2;
        [_mazeLayer addChild:_currentStart];
    }
    [_currentStart setPosition:_playerEntity.position];
    
    //创建&放置end点
    if (_currentEnd == nil) {
        _currentEnd = [Entity spriteWithFile:@"entity.png"];
        [_currentEnd setColor:ccRED];
        _currentEnd.scale=2;
        [_mazeLayer addChild:_currentEnd];
    }
    [_currentEnd setPosition:_desireEntity.position];
    
}
-(void)handlerGoBack{
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:gestureRecognizerPin];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:gestureRecognizerPan];
    [[[CCDirector sharedDirector] view] removeGestureRecognizer:gestureRecognizerTap];
}
#pragma mark guesture
-(void) handlePinchFrom:(UIPinchGestureRecognizer*)recognizer
{
    if (!_guiLayer.isOver ) {
        [_guiLayer modifySizeToNormal:NO];
    }
    
    if([recognizer state] == UIGestureRecognizerStateBegan)  //1
    {
        lastScale = _mazeLayer.scale; //2
    }else if ([recognizer state] == UIGestureRecognizerStateChanged)
    {
        float nowScale;    //3
        float tmpS = (lastScale - 1) + recognizer.scale;
//        nowScale=lastScale+(tmpS-lastScale)/2;//减缓放缩速度
        nowScale=tmpS;
//        CCLOG(@"nowScale--:%f,tmpS--:%f,lastScale--:%f",nowScale,tmpS,lastScale);
        nowScale = MIN(nowScale,2);//设置缩放上限   //5
        nowScale = MAX(nowScale,0.3);//设置缩放下限   //6
        _mazeLayer.scale = nowScale;//7
    }
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateBegan)
    {
        lastPosition = _mazeLayer.position;
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = ccp(translation.x, -translation.y);
        //乘以了0.7f是因为觉得位移太灵敏了，通过乘以一个小于1的数，相当于减小了这个位移量
        translation = ccpMult(translation, 0.7f);
        CGPoint newPos = ccpAdd(lastPosition, translation);
        //加入允许的范围的判断
        _mazeLayer.position = newPos;
    }
    
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
//        CCLOG(@"handleDoubleTapGesture------");
        if(_guiLayer.isPause
           && !_guiLayer.isOver
           && _mazeLayer.scale!=1){
            [_guiLayer modifySizeToNormal:YES];
            _mazeLayer.scale=1;
        }
    }
}
#pragma mark touches
#if 1
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
//    NSLog(@"--self.position x:%f,y:%f",self.position.x,self.position.y);

}

- (void)ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_guiLayer.isOver && !_guiLayer.isPause) {
        UITouch *touch = [touches anyObject];
        CGPoint location = [[CCDirector sharedDirector]
                            convertToGL:[touch locationInView:touch.view]
                            ];
        //这里点击有些偏移，因此需要手动修改
        float diffx=15;float diffy=18;
        //        CGPoint endPosition = ccpAdd( ccpSub(location, self.position),ccp(15, 18));
        CGPoint tempPosition = ccpSub(location, _mazeLayer.position);
//        CGPoint endPosition=ccpDiv(tempPosition,mazeScale);
//        CGPoint endPosition=ccpMult(tempPosition,mazeScale);
        CGPoint endPosition=tempPosition;
//        NSLog(@"ccTouchesEnded---tempPosition x:%f,y:%f\n\
              endPosition x:%f,y:%f \
              mazelayer Position x:%f,y:%f w:%f,h:%f; mazeScale:%f" \
              ,tempPosition.x,tempPosition.y \
              ,endPosition.x,endPosition.y \
              ,_mazeLayer.position.x,_mazeLayer.position.y \
              ,_mazeGenerator.size.width,_mazeGenerator.size.height \
              ,_mazeLayer.scale);
        if (endPosition.x>-diffx
            && endPosition.y>-diffy
            && endPosition.x<(_mazeGenerator.size.width+diffx)
            && endPosition.y<(_mazeGenerator.size.height+diffy)) {
            if ([_mazeGenerator showShotPath:_playerEntity.position endingAt:endPosition ]) {
                if ([SysConfig needAudio]){
                    [[SimpleAudioEngine sharedEngine] playEffect:@"put_role.wav"];
                }
                [_mazeGenerator showShotPath:_currentStart.position endingAt:endPosition movingEntity:_playerEntity];
                if ([_mazeGenerator isDesirePosition:endPosition desirePosition:_currentEnd.position]) {
                    NSLog(@"GameLayer--great!!! you win!!!!!");
                    [_guiLayer showOperationLayer:YES type:tLayerWin];
                }
            }else{
                if ([SysConfig needAudio]){
                    [[SimpleAudioEngine sharedEngine] playEffect:@"not_available.wav"];
                }
            }
            
        } else {
            if ([SysConfig needAudio]){
                [[SimpleAudioEngine sharedEngine] playEffect:@"not_available.wav"];
            }
            NSLog(@"touch is out of the maze..");
        }
    }
    
}
#endif
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_mazeGenerator release];
    [super dealloc];
}
@end