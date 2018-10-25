//
//  CheckUserInput.swift
//  CoordinateCalculator
//
//  Created by 윤동민 on 2018. 10. 19..
//  Copyright © 2018년 Codesquad Inc. All rights reserved.
//

import Foundation

extension String {
    // 스트링의 첫번째 문자 리턴
    func getFirstElement() -> Character{
        let firstIndex = self.index(self.startIndex, offsetBy: 0)
        return self[firstIndex]
    }
    
    // 스트링의 마지막 문자 리턴
    func getLastElement() -> Character{
        let endIndex = self.index(self.endIndex, offsetBy: -1)
        return self[endIndex]
    }
    
    // 스트링으로부터 Point를 추출
    func extractPosition() -> [String]{
        return self.components(separatedBy: ["(", ",", ")"])
    }
}

struct CheckUserInput {
    // 입력에 대한 Error 내역을 한 좌표씩 검사
    func checkErrorState(checkToInput: String) -> InputState{
        var inputState : InputState
        for point in checkToInput.split(separator: "-").map(String.init){
            inputState = checkPoint(point)
            guard inputState == .rightInput else { return inputState }
        }
        return .rightInput
    }
    
    // 포인트에 대해 오류를 검사하여 오류 내용 리턴
    func checkPoint(_ point: String) -> InputState{
        guard IsPossibleInputCharacter(point) else { return .outOfRangeCharacter }
        guard IsRightOrderInput(point) else { return .wrongOrder }
        guard IsRightForm(point) else { return .wrongOrder }
        guard IsOverFlowNumber(point) else { return .overFlowNumber }
        return .rightInput
    }
    
    // CharacterSet에 포함되지 않는 입력인지 검사
    private func IsPossibleInputCharacter(_ point: String) -> Bool{
        let possibleInputSet = CharacterSet.init(charactersIn: "0123456789(,)")
        if point == "" { return false }
        for element in point{
            guard String(element).rangeOfCharacter(from: possibleInputSet) != nil else { return false }
        }
        return true
    }
    
    // 입력 순서가 "(", ",", ")" 순서로 들어왔는지 검사
    private func IsRightOrderInput(_ point: String) -> Bool {
        guard point.getFirstElement() == "(" && point.getLastElement() == ")" && point.contains(",") else { return false }
        return true
    }
    
    // 입력 형태가 (x,y)인지 검사
    private func IsRightForm(_ point: String) -> Bool{
        guard Int(point.extractPosition()[1]) != nil && Int(point.extractPosition()[2]) != nil else { return false }
        return true
    }
    
    // 범위를 초과하였는지 검사
    private func IsOverFlowNumber(_ point: String) -> Bool{
        guard let positionX = Int(point.extractPosition()[1]) else { return false }
        guard let positionY = Int(point.extractPosition()[2]) else { return false }
        guard positionX <= 24 && positionX >= 0 && positionY <= 24 && positionY >= 0 else { return false }
        return true
    }
}
