import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImageListCellDelegate {
    
    @IBOutlet weak private var tableView: UITableView!
    
    private var photos: [Photo] = []
    private let imageListService = ImagesListService.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                updateTableViewAnimated()
            }
        imageListService.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            guard let indexPath = sender as? IndexPath else { return }
            viewController?.fullImageUrl = photos[indexPath.row].fullImageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let image = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.delegate = self
        let photo = photos[indexPath.row]
        if let url = URL(string: photo.thumbImageURL) {
            cell.cellImage.kf.indicatorType = .activity
            cell.cellImage.kf.setImage(with: url,placeholder: UIImage(named: "scribble.variable"),options: [])
            { [weak self] result in
                guard let self = self else { return }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
                switch result {
                case .success:
                    if let created = photo.createdAt {
                        cell.dateLabel.text = self.dateFormatter.string(from: created)
                    } else {
                        cell.dateLabel.text = ""
                    }
                    let isLikedd = imageListService.photos[indexPath.row].isLiked == false
                    cell.setIsLiked(isLikedd)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imageListService.photos.count {
            imageListService.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates{
                let indexPaths = (oldCount..<newCount).map { i in IndexPath(row: i, section: 0) }
                tableView.insertRows(at: indexPaths, with: .bottom)
            } completion: { _ in }
        }
    }
}

extension ImagesListViewController {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        let isLiked = photo.isLiked
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: isLiked) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    cell.setIsLiked(isLiked)
                    if let index = self.photos.firstIndex(where: { $0.id == photo.id }) {
                        let currentPhoto = self.photos[index]
                        let updatedPhoto = Photo(
                            id: currentPhoto.id,
                            size: currentPhoto.size,
                            createdAt: currentPhoto.createdAt,
                            welcomeDescription: currentPhoto.welcomeDescription,
                            thumbImageURL: currentPhoto.thumbImageURL,
                            largeImageURL: currentPhoto.largeImageURL,
                            fullImageUrl: currentPhoto.fullImageUrl,
                            isLiked: !currentPhoto.isLiked
                        )
                        self.photos.remove(at: index)
                        self.photos.insert(updatedPhoto, at: index)
                    }
                case .failure(let error):
                    print("Error changing like: \(error)")
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
