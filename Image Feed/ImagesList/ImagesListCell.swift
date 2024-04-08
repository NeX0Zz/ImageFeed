import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    weak var delegate: ImageListCellDelegate?
    
    override func prepareForReuse() {
          super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
      }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked{
            likeButton.imageView?.image = UIImage(named: "like_button_on")
        } else {
            likeButton.imageView?.image = UIImage(named: "like_button_off")
        }
    }
    
    @IBAction func likeButtonTap(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
}

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
