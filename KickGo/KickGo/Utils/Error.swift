
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
