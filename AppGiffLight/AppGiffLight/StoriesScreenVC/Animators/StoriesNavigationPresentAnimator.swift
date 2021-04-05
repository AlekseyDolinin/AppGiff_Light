import UIKit

class StoriesNavigationPresentAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let startFrame: CGRect

    init(startFrame: CGRect) {
        self.startFrame = startFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let snapshot = toViewController.view.snapshotView(afterScreenUpdates: true)
        else {
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        toViewController.view.isHidden = true
        snapshot.frame = startFrame
        snapshot.alpha = 0.0
        containerView.addSubview(snapshot)

        UIView.animate(withDuration: 0.3, animations: {
            snapshot.frame = (transitionContext.finalFrame(for: toViewController))
            snapshot.alpha = 1.0
        }, completion: { _ in
            toViewController.view.isHidden = false
            snapshot.removeFromSuperview()
            if transitionContext.transitionWasCancelled {
                toViewController.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

