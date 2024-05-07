//
//  ViewController.swift
//  Study Diary
//
//  Created by YS P on 5/7/24.
//

import UIKit

var memberDataManager = MemberDataManager()

class ViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 120
        
        tableView.delegate = self
        
        title = "멤버"
        memberDataManager.makeMemberData()
        
        tableView.reloadData()
    }
    
    @IBAction func barButtonTapped(_ sender: UIBarButtonItem) {

    }
    

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //몇 개의 컨텐츠를 보여줄지
        return memberDataManager.getMemberData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //재사용이 가능한 셀을 꺼낸다.
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        
        let array = memberDataManager.getMemberData()
        
        let member = array[indexPath.row]
        
        cell.mainImageView.image = member.memberImage //row행
        cell.memberNameLabel.text = member.memberName
        cell.memberDescriptionLabel.text = member.memberDescription
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toMemberDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemberDetail" {
            let detailVC = segue.destination as! MemberDetailViewController
            
            let array = memberDataManager.getMemberData()
            
            let indexPath = sender as! IndexPath
            
            detailVC.memberData = array[indexPath.row]
        }
    }
}
