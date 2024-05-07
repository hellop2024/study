//
//  MemberDataManager.swift
//  Study Diary
//
//  Created by YS P on 5/7/24.
//

import UIKit

class MemberDataManager {
    var memberDataArray: [Member] = []
    
    func makeMemberData() {
        memberDataArray = [
        Member(memberImage: UIImage(named: "batman.png"), memberName: "배트맨", memberDescription: "박쥐인"),
        Member(memberImage: UIImage(named: "captain.png"), memberName: "캡틴 아메리카", memberDescription: "방패든 미국인"),
        Member(memberImage: UIImage(named: "ironman.png"), memberName: "아이언맨", memberDescription: "철인"),
        Member(memberImage: UIImage(named: "thor.png"), memberName: "토르", memberDescription: "망치든 근육맨"),
        Member(memberImage: UIImage(named: "hulk.png"), memberName: "헐크", memberDescription: "초록 괴력인"),
        Member(memberImage: UIImage(named: "spiderman.png"), memberName: "스파이더맨", memberDescription: "거미인"),
        Member(memberImage: UIImage(named: "blackpanther.png"), memberName: "블랙팬서", memberDescription: "검은 고양이과인"),
        Member(memberImage: UIImage(named: "doctorstrange.png"), memberName: "닥터스트레인지", memberDescription: "의사출신 마법사"),
        Member(memberImage: UIImage(named: "guardians.png"), memberName: "가디언즈 오브 갤럭시", memberDescription: "음악 좋아하는 외계인 모임")
        ]
    }

    func getMemberData() -> [Member] {
        return memberDataArray
    }
    
    func updateMemberData(_ member: Member) {
        memberDataArray.append(member)
    }
}
