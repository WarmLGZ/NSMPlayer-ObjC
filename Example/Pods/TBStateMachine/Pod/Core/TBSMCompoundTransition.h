//
//  TBSMCompoundTransition.h
//  TBStateMachine
//
//  Created by Julian Krumow on 21.03.15.
//  Copyright (c) 2014-2016 Julian Krumow. All rights reserved.
//

#import "TBSMTransition.h"
#import "TBSMTransitionVertex.h"
#import "TBSMPseudoState.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This class represents a compound transition inside a state machine.
 */
@interface TBSMCompoundTransition : TBSMTransition

/**
 *  The target pseudo state.
 */
@property (nonatomic, strong) TBSMPseudoState *targetPseudoState;

/**
 *  Initializes a `TBSMCompoundTransition` instance from a given source and target state, action and guard.
 *
 *  @param sourceState       The specified source state.
 *  @param targetPseudoState The specified target pseudostate.
 *  @param action            The action associated with this transition.
 *  @param guard             The guard function associated with the transition.
 *
 *  @return The initialized compound transition instance.
 */
- (instancetype)initWithSourceState:(TBSMState *)sourceState
                  targetPseudoState:(TBSMPseudoState *)targetPseudoState
                             action:(nullable TBSMActionBlock)action
                              guard:(nullable TBSMGuardBlock)guard;
@end
NS_ASSUME_NONNULL_END
