//
//  MyTableViewController.swift
//  TodoListWithoutStoryboard
//
//  Created by Joshua Madrigal on 4/27/19.
//  Copyright © 2019 joshuamadrigal. All rights reserved.
//

import UIKit

class MyTableViewController: UITableViewController {
    
    var items = ["Item 1"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List Tableview"
        
        tableView.register(MyCell.self, forCellReuseIdentifier: "cellId")
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: "headerId")
        
        tableView.sectionHeaderHeight = 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: #selector(insert))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batch Insert", style: .plain, target: self, action: #selector(insertBatch))
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func insertBatch() {
        var indexPaths = [NSIndexPath]()
        for i in items.count...items.count + 5 {
            items.append("Items \(i + 1)")
            indexPaths.append(NSIndexPath(row: i, section: 0))
        }
        
        var bottomHalfIndexPaths = [NSIndexPath]()
        for _ in 0...indexPaths.count / 2 - 1 {
            bottomHalfIndexPaths.append(indexPaths.removeLast())
        }
        
        tableView.beginUpdates()
        
        tableView.insertRows(at: indexPaths as [IndexPath], with: .right)
        tableView.insertRows(at: bottomHalfIndexPaths as [IndexPath], with: .left)
        
        tableView.endUpdates()
        
    }
    
    @objc func insert() {
        items.append("Item \(items.count + 1)")
        let insertionIndexPath = NSIndexPath(row: items.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath as IndexPath], with: .automatic)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! MyCell
        myCell.nameLabel.text = items[indexPath.row]
        myCell.myTableViewController = self
        return myCell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerId")
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletionIndexPath = tableView.indexPath(for: cell) {
            items.remove(at: deletionIndexPath.row)
            tableView.deleteRows(at: [deletionIndexPath], with: .automatic)
        }
        
    }
    

} // end MyTableViewController class

class Header: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder): has not been implemented")
        
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Header"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
        
    }

}


class MyCell: UITableViewCell {
    var myTableViewController: MyTableViewController?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Init(coder): has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample item"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel, "v1": actionButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[v0]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["v0" : actionButton]))
        
    }
    
    @objc func handleAction() {
        myTableViewController?.deleteCell(cell: self)
    }
    
    
    
} // end MyCell class

