//
//  TBSMCompoundTransition.m
//  TBStateMachine
//
//  Created by Julian Krumow on 21.03.15.
//  Copyright (c) 2014-2016 Julian Krumow. All rights reserved.
//

#import "TBSMCompoundTransition.h"
#import "TBSMStateMachine.h"
#import "TBSMState.h"
#import "TBSMFork.h"
#import "TBSMJoin.h"
#import "TBSMJunction.h"

@interface TBSMCompoundTransition ()

@end

@implementation TBSMCompoundTransition

- (instancetype)initWithSourceState:(TBSMState *)sourceState
                  targetPseudoState:(TBSMPseudoState *)targetPseudoState
                             action:(TBSMActionBlock)action
                              guard:(TBSMGuardBlock)guard
{
    self = [super init];
    if (self) {
        self.sourceState = sourceState;
        self.targetPseudoState = targetPseudoState;
        self.targetState = targetPseudoState.targetState;
        self.action = action;
        self.guard = guard;
    }
    return self;
}

- (NSString *)name
{
    NSString *source = nil;
    NSString *target = nil;
    if ([self.targetPseudoState isKindOfClass:[TBSMJoin class]]) {
        TBSMJoin *join = (TBSMJoin *)self.targetPseudoState;
        source = [NSString stringWithFormat:@"[%@](%@)", [[join.sourceStates valueForKeyPath:@"name"] componentsJoinedByString:@","], join.region.name];
        target = self.targetState.name;
    }
    if ([self.targetPseudoState isKindOfClass:[TBSMFork class]]) {
        TBSMFork *fork = (TBSMFork *)self.targetPseudoState;
        source = self.sourceState.name;
        target = [NSString stringWithFormat:@"[%@](%@)", [[fork.targetStates valueForKeyPath:@"name"] componentsJoinedByString:@","], fork.region.name];
    }
    if ([self.targetPseudoState isKindOfClass:[TBSMJunction class]]) {
        TBSMJunction *junction = (TBSMJunction *)self.targetPseudoState;
        source = self.sourceState.name;
        target = [NSString stringWithFormat:@"[%@]", [[junction.targetStates valueForKeyPath:@"name"] componentsJoinedByString:@","]];
    }
    return [NSString stringWithFormat:@"%@ --> %@ --> %@", source, self.targetPseudoState.name, target];
}

- (BOOL)performTransitionWithData:(id)data
{
    if (self.guard == nil || self.guard(data)) {
        if ([self.targetPseudoState isKindOfClass:[TBSMFork class]]) {
            [self _performForkTransitionWithData:data];
        } else if ([self.targetPseudoState isKindOfClass:[TBSMJoin class]]) {
            [self _performJoinTransitionWithData:data];
        } else if ([self.targetPseudoState isKindOfClass:[TBSMJunction class]]) {
            [self _performJunctionTransitionWithData:data];
        }
        return YES;
    }
    return NO;
}

- (void)_performForkTransitionWithData:(id)data
{
    TBSMFork *fork = (TBSMFork *)self.targetPseudoState;
    [self _validatePseudoState:fork states:fork.targetStates region:fork.region];
    TBSMStateMachine *lca = [self findLeastCommonAncestor];
    [lca switchState:self.sourceState targetStates:fork.targetStates region:(TBSMParallelState *)fork.targetState action:self.action data:data];
}

- (void)_performJoinTransitionWithData:(id)data
{
    TBSMJoin *join = (TBSMJoin *)self.targetPseudoState;
    [self _validatePseudoState:join states:join.sourceStates region:join.region];
    if ([join joinSourceState:self.sourceState]) {
        TBSMStateMachine *lca = [self findLeastCommonAncestor];
        [lca switchState:self.sourceState targetState:self.targetState action:nil data:data];
    }
}

- (void)_performJunctionTransitionWithData:(id)data
{
    TBSMJunction *junction = (TBSMJunction *)self.targetPseudoState;
    TBSMJunctionPath *outgoingPath = [junction outgoingPathForTransition:self.sourceState data:data];
    self.targetState = outgoingPath.targetState;
    TBSMStateMachine *lca = [self findLeastCommonAncestor];
    TBSMActionBlock compoundAction = ^(id data) {
        if (self.action) {
            self.action(data);
        }
        if (outgoingPath.action) {
            outgoingPath.action(data);
        }
    };
    [lca switchState:self.sourceState targetState:self.targetState action:compoundAction data:data];
}

- (void)_validatePseudoState:(TBSMPseudoState *)pseudoState states:(NSArray *)states region:(TBSMParallelState *)region
{
    for (TBSMState *state in states) {
        if (![state.path containsObject:region]) {
            @throw [NSException tb_ambiguousCompoundTransitionAttributes:pseudoState.name];
        }
    }
}

@end
