import Foundation

class TestSentryDispatchQueueWrapper: SentryDispatchQueueWrapper {
    
    var dispatchAsyncCalled = 0
    
    override func dispatchAsync(_ block: @escaping () -> Void) {
        dispatchAsyncCalled += 1
        block()
    }
    
    var blockOnMainInvocations = Invocations<() -> Void>()
    var blockBeforeMainBlock : () -> Bool = { true }
    
    override func dispatch(onMainQueue block: @escaping () -> Void) {
        blockOnMainInvocations.record(block)
        if blockBeforeMainBlock() {
            block()
        }
    }
    
    var dispatchAfterInvocations = Invocations<(when: dispatch_time_t, block: () -> Void)>()
    override func dispatch(after when: dispatch_time_t, block: @escaping () -> Void) {
        dispatchAfterInvocations.record((when, block))
    }
    
    func invokeDispatchAfter() {
        dispatchAfterInvocations.invocations.forEach {
            $0.block()
        }
    }
    
    override func dispatchOnce(_ predicate: UnsafeMutablePointer<Int>, block: @escaping () -> Void) {
        block()
    }
}
