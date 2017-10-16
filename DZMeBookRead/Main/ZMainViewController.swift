//
//  ZMainViewController.swift
//  DZMeBookRead
//
//  Created by zhz on 16/10/2017.
//  Copyright © 2017 Z. All rights reserved.
//

import UIKit

class ZMainViewController: DZMViewController {
    
    let tableView: UITableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
    var dataSource: [ZBookListModel] = []
    
    override func viewDidLoad() {
        setupUI()
        addObserver()
    }
    
    func setupUI() -> Void {
        title = "小说列表"
        view.backgroundColor = UIColor.white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "listCell")
        view.addSubview(tableView)
    }
    
    func addObserver() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(readBookList(notify:)), name: NSNotification.Name(rawValue: kBooksHasLoadNotify), object: nil)
    }
    
    func readBookList(notify: Notification) -> Void {
        let bookList: [String] = notify.object as! [String]
        dataSource.removeAll()
        for book in bookList {
            let bookModel: ZBookListModel = ZBookListModel()
            bookModel.title = book.stringByDeletingPathExtension()
            let documents: String = NSHomeDirectory() + "/Documents"
            bookModel.filePath = documents + "/" + book
            dataSource.append(bookModel)
        }
        tableView.reloadData()
        print(dataSource as Any)
    }
}

extension ZMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
        let bookModel: ZBookListModel = dataSource[indexPath.row]
        cell.textLabel?.text = bookModel.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        MBProgressHUD.showMessage("解析中...")
        let bookModel: ZBookListModel = dataSource[indexPath.row]
        let url = URL(fileURLWithPath: bookModel.filePath!)
        
        DZMReadParser.ParserLocalURL(url: url as URL) {[weak self] (readModel) in
            MBProgressHUD.hide()
            let readController = DZMReadController()
            readController.readModel = readModel
            self?.navigationController?.pushViewController(readController, animated: true)
        }
        
    }
}

