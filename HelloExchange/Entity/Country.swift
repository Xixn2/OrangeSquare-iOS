//
//  Country.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/25/25.
//

import Foundation

enum Country: String, CaseIterable {
    case TT = "TT" // 트리니다드 토바고
    case SL = "SL" // 시에라리온
    case SA = "SA" // 사우디아라비아
    case PG = "PG" // 파푸아뉴기니
    case PY = "PY" // 파라과이
    case CA = "CA" // 캐나다
    case IL = "IL" // 이스라엘
    case JP = "JP" // 일본
    case PK = "PK" // 파키스탄
    case LY = "LY" // 리비아
    case BD = "BD" // 방글라데시
    case MO = "MO" // 마카오
    case AZ = "AZ" // 아제르바이잔
    case NG = "NG" // 나이지리아
    case BH = "BH" // 바레인
    case NA = "NA" // 나미비아
    case MK = "MK" // 북마케도니아
    case UA = "UA" // 우크라이나
    case AL = "AL" // 알바니아
    case PL = "PL" // 폴란드
    case HT = "HT" // 아이티
    case LK = "LK" // 스리랑카
    case ZW = "ZW" // 짐바브웨
    case UG = "UG" // 우간다
    case GB = "GB" // 영국
    case GY = "GY" // 가이아나
    case AM = "AM" // 아르메니아
    case AF = "AF" // 아프가니스탄
    case GE = "GE" // 조지아
    case UY = "UY" // 우루과이
    case KY = "KY" // 케이맨 제도
    case VN = "VN" // 베트남
    case AW = "AW" // 아루바
    case YE = "YE" // 예멘
    case DK = "DK" // 덴마크
    case FJ = "FJ" // 피지
    case FK = "FK" // 포클랜드 제도
    case AR = "AR" // 아르헨티나
    case SH = "SH" // 세인트헬레나
    case KZ = "KZ" // 카자흐스탄
    case TJ = "TJ" // 타지키스탄
    case CH = "CH" // 스위스
    case PA = "PA" // 파나마
    case AO = "AO" // 앙골라
    case UZ = "UZ" // 우즈베키스탄
    case ST = "ST" // 상투메 프린시페
    case KE = "KE" // 케냐
    case ZM = "ZM" // 잠비아
    case TR = "TR" // 터키
    case RO = "RO" // 루마니아
    case ID = "ID" // 인도네시아
    case SN = "SN" // 세네갈 (XOF 사용국 대표)
    case PF = "PF" // 프랑스령 폴리네시아
    case SE = "SE" // 스웨덴
    case NP = "NP" // 네팔
    case BR = "BR" // 브라질
    case JM = "JM" // 자메이카
    case MX = "MX" // 멕시코
    case ZA = "ZA" // 남아프리카공화국
    case LB = "LB" // 레바논
    case US = "US" // 미국
    case CZ = "CZ" // 체코
    case TH = "TH" // 태국
    case SR = "SR" // 수리남
    case CN = "CN" // 중국
    case EG = "EG" // 이집트
    case BN = "BN" // 브루나이
    case BS = "BS" // 바하마
    case SG = "SG" // 싱가포르
    case MA = "MA" // 모로코
    case HK = "HK" // 홍콩
    case MY = "MY" // 말레이시아
    case TW = "TW" // 대만
    case PH = "PH" // 필리핀
    case NO = "NO" // 노르웨이
    case EU = "EU" // 유럽연합 (유로 통화권)
    case IN = "IN" // 인도
    case DO = "DO" // 도미니카공화국
    case HU = "HU" // 헝가리
    case KR = "KR" // 대한민국
    case RU = "RU" // 러시아
    case MM = "MM" // 미얀마 (M
    case AE = "AE" // 아랍에미리트 (United Arab Em
    case KH = "KH" // 캄보디아 (Ca
    case CL = "CL" // 칠레
    case PE = "PE" // 페루
    case LA = "LA" // 라오스
    case AU = "AU" // 호주
}


extension Country {
    var thumbnailUrl: URL? {
        return URL(string: "https://flagsapi.com/\(rawValue)/flat/64.png")
    }
}
