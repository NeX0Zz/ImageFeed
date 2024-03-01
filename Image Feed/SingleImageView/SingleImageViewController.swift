import UIKit

final class SingleImageViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    // MARK: - Properties
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Overrides funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.frame.size = image.size
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 4.5
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        rescaleAndCenterImageInScrollView(image: image)
        
        self.scrollView.isUserInteractionEnabled = true
    }
    
    // MARK: - Private funcs
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        if scrollView.zoomScale < scale {
            scrollView.setZoomScale(scale, animated: true)
        }
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let topInset = (visibleRectSize.height - newContentSize.height) / 2
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: IBActions
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Extension

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        rescaleAndCenterImageInScrollView(image: image)
    }
}
