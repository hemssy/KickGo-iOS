
//  로그인 에러 타입
enum LoginError: Error{
    case emptyField
    case incorrectID
    case incorrectpaswword
    
    var message: String{
        switch self{
        case .emptyField:
            return "이메일과 비밀번호를 입력하세요."
        case .incorrectID:
            return "존재하지 않는 이메일입니다."
        case .incorrectpaswword:
            return "비밀번호가 올바르지 않습니다."
        }
    }
}

// 회원가입 에러 타입
enum SignUpError:Error{
    case emptyField
    case inValidEmail
    case inValidPhoneNums
    
    var message: String{
        switch self{
        case .emptyField:
            return "모든 항목을 입력해주세요."
        case .inValidEmail:
            return "유효하지 않은 이메일입니다."
        case .inValidPhoneNums:
            return "유효하지 않은 전화번호입니다."
        }
    }
}

// 등록 에러 타입
enum RegisterError: Error{
    case searchResultError
    case minBattaryError
    case maxBattaryError
    
    var message: String{
        switch self{
        case .searchResultError:
            return "검색 결과를 찾을 수 없습니다."
        case .minBattaryError:
            return "배터리 잔량은 0보다 커야 합니다."
        case .maxBattaryError:
            return "배터리 잔량은 1~100 사이의 숫자여야 합니다."
        }
    }
}
