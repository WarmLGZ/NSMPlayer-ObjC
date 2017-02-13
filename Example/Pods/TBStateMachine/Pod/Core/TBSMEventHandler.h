//
//  TBSMEventHandler.h
//  TBStateMachine
//
//  Created by Julian Krumow on 07.09.14.
//  Copyright (c) 2014-2016 Julian Krumow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBSMTransition.h"
#import "TBSMState.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This class represents an event handler object.
 *  It stores information associated with a given event registered on a `TBSMState` instance.
 */
@interface TBSMEventHandler : NSObject

/**
 *  The event's name.
 */
@property (nonatomic, copy) NSString *name;

/**
 *  The target vertex of the transition triggered by the event.
 */
@property (nonatomic, strong) id <TBSMTransitionVertex> target;

/**
 *  The kind of transition to perform.
 */
@property (nonatomic, assign) TBSMTransitionKind kind;

/**
 *  The action of the transition triggered by the event.
 */
@property (nonatomic, copy, nullable) TBSMActionBlock action;

/**
 *  The guard function of the transition triggered by the event.
 */
@property (nonatomic, copy, nullable) TBSMGuardBlock guard;

/**
 *  Initializes a `TBSMEventHandler` from a given event name, target, action and guard.
 *
 *  Throws a `TBSMException` when name is nil or an empty string.
 *
 *  @param name   The name of this event. Must be unique.
 *  @param target The target vertex.
 *  @param kind   The kind of transition.
 *  @param action The action.
 *  @param guard  The guard function.
 *
 *  @return An initialized `TBSMEventHandler` instance.
 */
- (instancetype)initWithName:(NSString *)name target:(id <TBSMTransitionVertex>)target kind:(TBSMTransitionKind)kind action:(nullable TBSMActionBlock)action guard:(nullable TBSMGuardBlock)guard;

@end
NS_ASSUME_NONNULL_END
