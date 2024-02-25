import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private var label: UILabel?
    private var label2: UILabel?
    private var label3: UILabel?
    
    // MARK: - Overrides funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView()
    }
    
    // MARK: - funcs
    
    func imageView(){
        let profileImage = UIImage(named: "avatar")
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let label = UILabel()
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "YP White")
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        view.addSubview(label)
        
        label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 18).isActive = true
        self.label = label
        
        
        let label2 = UILabel()
        label2.text = "@ekaterina_nov"
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.textColor = UIColor(named: "YP Gray")
        label2.font = UIFont.systemFont(ofSize: 13)
        
        view.addSubview(label2)
        
        label2.leadingAnchor.constraint(equalTo: label.leadingAnchor).isActive = true
        label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 18).isActive = true
        self.label2 = label2
        
        let label3 = UILabel()
        label3.text = "Hello, world!"
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.textColor = UIColor(named: "YP White")
        label3.font = UIFont.systemFont(ofSize: 13)
        
        view.addSubview(label3)
        
        label3.leadingAnchor.constraint(equalTo: label2.leadingAnchor).isActive = true
        label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 18).isActive = true
        self.label3 = label3
        
        
        
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    // MARK: - Gestures
    
    @objc
    private func didTapButton() {
        for view in view.subviews {
            if view is UILabel {
                view.removeFromSuperview()
            }
        }
    }
}

