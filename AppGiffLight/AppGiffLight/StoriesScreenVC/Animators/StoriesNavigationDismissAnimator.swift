import UIKit

class StoriesNavigationDismissAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    private let endFrame: CGRect

    init(endFrame: CGRect) {
        self.endFrame = endFrame
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let snapshot = fromViewController.view.snapshotView(afterScreenUpdates: true)
        else {
            return
        }
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshot)
        fromViewController.view.isHidden = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            snapshot.frame = self.endFrame
            snapshot.alpha = 0
        }, completion: { _ in
            fromViewController.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }

}

