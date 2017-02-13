//
//  TBSMSubState.h
//  TBStateMachine
//
//  Created by Julian Krumow on 19.09.14.
//  Copyright (c) 2014-2016 Julian Krumow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSMState.h"
#import "TBSMContainingNode.h"

NS_ASSUME_NONNULL_BEGIN

@class TBSMStateMachine;

/**
 *  This class allows the create nested states.
 */
@interface TBSMSubState : TBSMState <TBSMContainingNode>

/**
 *  The `TBSMStateMachine` instance contained in this sub state.
 */
@property (nonatomic, strong) TBSMStateMachine *stateMachine;

/**
 *  Creates a `TBSMSUBState` with a specified name.
 *
 *  Throws a `TBSMException` when name is nil or an empty string.
 *
 *  @param name The name of this wrapper. Must be unique.
 *
 *  @return A new `TBSMSubState` instance.
 */
+ (instancetype)subStateWithName:(NSString *)name;

@end
NS_ASSUME_NONNULL_END
