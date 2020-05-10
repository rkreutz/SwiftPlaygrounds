import Foundation

// MARK: - Basic structures

/// This is just a Dummy class with an id
class Dummy: CustomDebugStringConvertible {

    /// The debug description will be something like: Dummy 1 (0x0001324) i.e. Class id (memory reference)
    var debugDescription: String {

        return "Dummy \(id) (\(Unmanaged.passUnretained(self).toOpaque()))"
    }

    let id: Int

    init(_ id: Int) {

        print("Init Dummy \(id)")
        self.id = id
    }

    deinit {

        print("Deinit \(self)")
    }

    func randomMethod() -> Void {

        print("I'm a method from \(self)")
    }
}

var closure: () -> Void = { }

/// This is the parent who will be holding a strong and weak reference to a given Dummy
class ParentDummy: CustomDebugStringConvertible {

    /// The debug description will be something like: ParentDummy of "Dummy 1 (0x0001324)" (0x0002345) i.e. Class DummyReference (memory reference)
    var debugDescription: String {

        return "ParentDummy of \"\(strongDummy)\" (\(Unmanaged.passUnretained(self).toOpaque()))"
    }

    var strongDummy: Dummy
    weak var weakDummy: Dummy?

    init(_ dummy: Dummy) {

        print("Init ParentDummy of \"\(dummy)\"")
        self.strongDummy = dummy
        self.weakDummy = dummy
    }

    deinit {

        print("Deinit \(self)")
    }

    func randomMethod() {

        print("I'm a method of the parent \(self)")
    }
}

// MARK: - Several examples of memory management with ARC in practice

extension ParentDummy {

    /// This method sets the closure using self explicitly without any capture lists
    func setupClosureWithStrongSelf() {

        // This will create a strong reference to self in the closure, which will be held until the closure is disposed
        // This would be the same as if we had captured self strongly with:
        //closure = { [self] in
        closure = {

            self.weakDummy?.randomMethod()
        }
    }

    /// This method sets the closure using a weak self in the capture list
    func setupClosureWithWeakSelf() {

        closure = { [weak self] in

            // Here it doesn't matter if we use the strong or weak dummy, since who is being captured by the closure is self
            self?.strongDummy.randomMethod()
            //            self?.weakDummy?.randomMethod()
        }
    }

    /// This will create the closure with a weak reference to Dummy
    func setupClosureWithWeakDummy() {

        // This will pass a weak reference of dummy to the closure, which means that the closure itself won't count towards ARC releasing dummy
        // before it runs
        closure = { [weak weakDummy] in

            weakDummy?.randomMethod()
        }

        // It could be written like these as well:
        //        closure = { [weak strongDummy] in
        //
        //            strongDummy?.randomMethod()
        //        }

        //        weak var dummy = weakDummy
        //        closure = {
        //
        //            dummy?.randomMethod()
        //        }

        //        weak var weakStrongDummy = strongDummy
        //        closure = {
        //
        //            weakStrongDummy?.randomMethod()
        //        }
    }

    /// This method sets the closure to be random method of the weak dummy we have internally
    func setupClosureWithWeakDummyRandomMethod() {

        // closure will hold a strong reference to weakDummy, even though it is declared as a weak reference internally in ParentDummy, that
        // is because when creating an instance method Swift needs to have a strong reference to the instance of the method.
        closure = weakDummy?.randomMethod ?? {}

        // This line has the same effect as:
        //        closure = weakDummy.map { Dummy.randomMethod($0) } ?? {}
        //        closure = strongDummy.randomMethod
        //        closure = Dummy.randomMethod(strongDummy)
    }

    /// This method will set the closure to use self.randomMethod()
    func setupClosureWithStrongParent() {

        // This will create a strong reference to self in the closure.
        closure = self.randomMethod

        // These has the same effect
        //        closure = { self.randomMethod() }
        //        closure = { [self] in self.randomMethod() }
        //        closure = ParentDummy.randomMethod(self)
    }

    func setupClosureWithWeakDummyAndNestedClosureWithWeakSelf() {

        closure = { [weak weakDummy] in

            weakDummy?.randomMethod()

            // This is a closure that will be run automatically. Similar to a Router being called after some action and having a completion handler.
            // It has a weak reference to self, so you would think it would not have any leaks, however this closure is nested inside another
            // closure which means it is capturing self from the previous closure context, which means the previous closure will be implicitly
            // capturing self strongly. To fix this you must capture self weakly on the first closure and use that weak captured var
            _ = { [weak self] in

                self?.randomMethod()
                }()
        }

        // This has a similar effect:
        //        closure = { [weak weakDummy, weak self] in
        //
        //            guard let self = self else { return }
        //            weakDummy?.randomMethod()
        //
        //            _ = {
        //
        //                // Here you are using the strong reference from the guard let, if you want to use self in nested closures you must have
        //                // the weak and strong reference in separate variables and use the weak variable here. On this case it won't have a leak as the previous
        //                // example because we are getting rid of the closure imediatelly after running it (we are not holding a reference to it) whoever if this closure
        //                // were to be hold somewhere it could cause a leak.
        //                self.randomMethod()
        //            }()
        //        }
    }
}

// - MARK: The main executable of the Playground

// This do is just to create a quick context where we create a reference to the ParentDummy and when it's over ParentDummy should be
// disposed by ARC since we wouldn't have anymore strong references to ParentDummy
do {

    print("**** Creating references ****")
    let reference = ParentDummy(Dummy(3))
    print("**** Setting up the closure ****")
    // Just uncomment the line you want to experiment with, just be aware that the last uncommented line will be the one actually executed
//    reference.setupClosureWithStrongSelf()
//    reference.setupClosureWithWeakSelf()
//    reference.setupClosureWithWeakDummy()
//    reference.setupClosureWithWeakDummyRandomMethod()
//    reference.setupClosureWithStrongParent()
//    reference.setupClosureWithWeakDummyAndNestedClosureWithWeakSelf()
    print("**** Will leave context ****")
}
print("**** Do context was left ****")

print("**** Running the closure ****")
// We execute the closure that was configured by the do block before
closure()

print("**** Cleaning the closure ****")
// We clean the closure so any references being hold by it will be disposed
closure = {}
print("**** Playground has finished ****")
