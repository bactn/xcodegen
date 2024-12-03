//
//  ViewController.swift
//  Example
//
//  Created by Kita Tran on 25/06/2024.
//

import UIKit
import VTBMiniApp

struct MiniAppInfo {
    var appName: String
    var appFileName: String
    var appId: String
    var appVersion: String
}

let miniApps: [MiniAppInfo] = [
    MiniAppInfo(appName: "React JS mini app", appFileName: "js-miniapp-sample", appId: "js-mini-app-testing-appid", appVersion: "1.1.0"),
    MiniAppInfo(appName: "Flutter mini app", appFileName: "miniapp-flutter", appId: "flutter-id", appVersion: "1.0.0"),
    MiniAppInfo(appName: "HTML mini app", appFileName: "miniapp-html", appId: "html-id", appVersion: "1.0.0"),
    MiniAppInfo(appName: "Vue js mini app", appFileName: "miniapp-vue", appId: "vue-id", appVersion: "1.0.0"),]

class ViewController: UIViewController {
   
    @IBOutlet weak var mTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
    
    @IBAction func push(_ sender: Any) {
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miniApps.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = miniApps[indexPath.row].appName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appId = miniApps[indexPath.row].appId
        let appVer = miniApps[indexPath.row].appVersion
        let vc = MiniAppViewController(appId: appId, appVersion: appVer)
        self.present(vc, animated: true, completion: nil)
    }
}
