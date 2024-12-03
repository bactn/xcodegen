//
//  MiniAppViewController.swift
//  Example
//
//  Created by Kita Tran on 26/11/2024.
//

import UIKit
import VTBMiniApp

class MiniAppViewController: UIViewController, MiniAppNavigationDelegate {
    var appId: String
    var appVersion: String
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    init(appId: String, appVersion: String) {
        self.appId = appId
        self.appVersion = appVersion
        super.init(nibName: "MiniAppViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMiniAppView()
    }
    
    @IBAction func selectBack(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: Funcs
extension MiniAppViewController {
    
    func loadMiniAppView() {
        let miniAppView = MiniAppView(params: MiniAppViewParameters.default(miniAppViewParams(config: Config.sampleSdkConfig())))
        self.view.addSubview(miniAppView)
        miniAppView.frame = self.view.bounds
        miniAppView.layoutAttachAll()
        // load the miniapp
        miniAppView.loadFromBundle(miniAppManifest: getMiniAppManifest(), completion: { result in
            
        })
    }
    
    
    func miniAppViewParams(config: MiniAppSdkConfig) -> MiniAppViewParameters.DefaultParams {
        return MiniAppViewParameters.DefaultParams.init(
            config: MiniAppConfig(
                config: config,
                messageDelegate: self,
                navigationDelegate: MiniAppViewNavigationDelegator()
            ),
            type: .miniapp,
            appId: self.appId,
            version: self.appVersion,
            queryParams: nil
        )
    }
    
    func getMiniAppManifest() -> MiniAppManifest? {
        let manifest = MiniAppManifest(requiredPermissions: permissionList(),
                               optionalPermissions: nil,
                               customMetaData: nil,
                               accessTokenPermissions: [MASDKAccessTokenScopes(audience: "rae",
                                                                               scopes: ["idinfo_read_openid", "memberinfo_read_point"])!],
                                       versionId: self.appVersion)
        return manifest
    }

    private func permissionList() -> [MASDKCustomPermissionModel] {
        do {
            let permissions: [MiniAppCustomPermissionType] = [.userName, .profilePhoto, .contactsList, .fileDownload, .accessToken, .deviceLocation, .sendMessage, .points]

            return try permissions.map { try MASDKCustomPermissionModel.customPermissionModel(permissionName: $0) }
        } catch {
//            print("Failed to set up MiniApp permissions")
            return []
        }
    }

}

extension MiniAppViewController {
    func miniAppNavigation(shouldOpen url: URL, with responseHandler: @escaping VTBMiniApp.MiniAppNavigationResponseHandler, onClose closeHandler: VTBMiniApp.MiniAppNavigationResponseHandler?) {
        
    }
    
    func miniAppNavigation(shouldOpen url: URL, with responseHandler: @escaping VTBMiniApp.MiniAppNavigationResponseHandler, onClose closeHandler: VTBMiniApp.MiniAppNavigationResponseHandler?, customMiniAppURL: URL) {
        
    }
    
    func miniAppNavigation(canUse actions: [VTBMiniApp.MiniAppNavigationAction]) {
        
    }
    
    func miniAppNavigation(delegate: VTBMiniApp.MiniAppNavigationBarDelegate) {
        
    }
    
    func miniAppNavigationCanGo(back: Bool, forward: Bool) {
        
    }
    
    func downloadFile(fileName: String, url: String, headers: VTBMiniApp.DownloadHeaders, completionHandler: @escaping (Result<String, VTBMiniApp.MASDKDownloadFileError>) -> Void) {
        
    }
    
    func sendMessageToContact(_ message: VTBMiniApp.MessageToContact, completionHandler: @escaping (Result<String?, VTBMiniApp.MASDKError>) -> Void) {
        
    }
    
    func sendMessageToContactId(_ contactId: String, message: VTBMiniApp.MessageToContact, completionHandler: @escaping (Result<String?, VTBMiniApp.MASDKError>) -> Void) {
        
    }
    
    func sendMessageToMultipleContacts(_ message: VTBMiniApp.MessageToContact, completionHandler: @escaping (Result<[String]?, VTBMiniApp.MASDKError>) -> Void) {
        
    }
    
    func registerDrop(serviceCode: String, from vc: UIViewController) {
        
    }
    
    func registerSuccess(serviceCode: String, from vc: UIViewController) {
        
    }
    
    func signingSuccess(serviceCode: String, disbursementAccount: String, from vc: UIViewController) {
        
    }
    
    func signingFailed(serviceCode: String, disbursementAccount: String, from vc: UIViewController) {
        
    }
    
    func expiredSession() {
    }

}

extension MiniAppViewController: MiniAppMessageDelegate {
    func closeMiniApp(withConfirmation: Bool, completionHandler: @escaping (Result<Bool, MiniAppJavaScriptError>) -> Void) {
        self.dismiss(animated: true)
    }
    
    func isDarkMode(completionHandler: @escaping (Result<Bool, MiniAppJavaScriptError>) -> Void) {
        if UIWindow().traitCollection.userInterfaceStyle == .dark {
            completionHandler(.success(true))
            return
        }
        completionHandler(.success(false))
    }
}

extension MASDKCustomPermissionModel {
    static func customPermissionModel(permissionName: MiniAppCustomPermissionType, isPermissionGranted: MiniAppCustomPermissionGrantedStatus = .allowed, permissionRequestDescription: String? = "") throws -> Self {
        let data = [
            "permissionName": permissionName.rawValue,
            "isPermissionGranted": isPermissionGranted.rawValue,
            "permissionDescription": permissionRequestDescription
        ]

        let encodedData = try JSONEncoder().encode(data)

        return try JSONDecoder().decode(Self.self, from: encodedData)
    }
}

class Config {
    class func sampleSdkConfig() -> MiniAppSdkConfig {
        return MiniAppSdkConfig(baseUrl: "https://google.com.vn", rasProjectId: "test-project-id", subscriptionKey: "test-sub-key")
    }
}

class MiniAppViewNavigationDelegator: MiniAppNavigationDelegate {

    var onShouldOpenUrl: ((URL, MiniAppNavigationResponseHandler?, MiniAppNavigationResponseHandler?) -> Void)?
    var onChangeCanGoBackForward: ((_ back: Bool, _ forward: Bool) -> Void)?

    func miniAppNavigation(shouldOpen url: URL, with responseHandler: @escaping MiniAppNavigationResponseHandler, onClose closeHandler: MiniAppNavigationResponseHandler?) {
        if url.absoluteString.starts(with: "data:") {
            navigateForBase64(url: url)
        } else {
            guard !isDeepLinkURL(url: url) else {
                return
            }
            MiniAppExternalWebViewController.presentModally(
                url: url,
                externalLinkResponseHandler: responseHandler,
                onCloseHandler: closeHandler
            )
        }
    }

    func navigateForBase64(url: URL) {
        let topViewController = UIApplication.shared.keyWindow?.topController()
        // currently js sdk is passing no base64 data type
        let base64String = url.absoluteString.components(separatedBy: ",").last ?? ""
        guard let base64Data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) else { return }
        var activityItem: Any?
        if let image = UIImage(data: base64Data) {
            activityItem = image
        } else {
            activityItem = base64Data
        }
        guard let wrappedActivityItem = activityItem else { return }
        let activityViewController = MiniAppActivityController(activityItems: [wrappedActivityItem], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { (_, completed, _, _) in
            guard completed else { return }
            let controller = UIAlertController(title: "Nice", message: "Successfully shared!", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            topViewController?.present(controller, animated: true, completion: nil)
        }
        topViewController?.present(activityViewController, animated: true)
    }

    func isDeepLinkURL(url: URL) -> Bool {
        if getDeepLinksList().contains(where: url.absoluteString.hasPrefix) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return true
        }
        return false
    }

    func miniAppNavigationCanGo(back: Bool, forward: Bool) {
        onChangeCanGoBackForward?(back, forward)
    }
}

func getDeepLinksList(key: String = "DeeplinkList") -> [String] {
    if let deeplinksData = UserDefaults.standard.data(forKey: key) {
        let deeplinksList = try? PropertyListDecoder().decode([String].self, from: deeplinksData)
        return deeplinksList ?? []
    }
    return []
}
