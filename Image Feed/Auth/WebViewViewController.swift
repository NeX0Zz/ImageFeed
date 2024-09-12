import UIKit
import WebKit

fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

final class WebViewViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private weak var webView: WKWebView!
    
    // MARK: - Properties
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadAuthView()
        updateProgress()
        estimatedProgresObservation()
    }
    
    // MARK: - Private Methods
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: unsplashAuthorizeURLString) else {return}
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {return}
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func estimatedProgresObservation() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 updateProgress()
             })
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    // MARK: - IB Actions
    
    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        { return codeItem.value } else { return nil }
    }
    
    func webView(_ webView: WKWebView,decidePolicyFor navigationAction: WKNavigationAction,decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
