import UIKit

class StoriesNavigationController: UINavigationController {
        
    // MARK: - Private properties
    private var previewFrame: PreviewStoryViewProtocol?
    
    // MARK: - Setup
    func setup(viewController: UIViewController, previewFrame: PreviewStoryViewProtocol?) {
        self.previewFrame = previewFrame
        self.viewControllers = [viewController]
    }
    
    // MARK: - Lifecycle
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
}

extension StoriesNavigationController {
    
    private func setupUI() {
        setNavigationBarHidden(true, animated: false)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
}

extension StoriesNavigationController: UIViewControllerTransitioningDelegate {
    
    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        guard let startFrame = previewFrame?.startFrame else { return nil }
        return StoriesNavigationPresentAnimator(startFrame: startFrame)
    }
    
    public func animationController(
        forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        guard let endFrame = previewFrame?.endFrame else { return nil }
        return StoriesNavigationDismissAnimator(endFrame: endFrame)
    }
    
}


