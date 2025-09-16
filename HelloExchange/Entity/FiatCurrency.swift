//
//  FiatCurrency.swift
//  HelloExchange
//
//  Created by Subeen Park on 7/25/25.
//

enum FiatCurrency: String, CaseIterable {
    case usd = "USD" // 미국 달러
    case krw = "KRW" // 대한민국 원
    case eur = "EUR" // 유로
    case jpy = "JPY" // 일본 엔
    case gbp = "GBP" // 영국 파운드
    case cny = "CNY" // 중국 위안
    case aud = "AUD" // 호주 달러
    case cad = "CAD" // 캐나다 달러
    case chf = "CHF" // 스위스 프랑
    case inr = "INR" // 인도 루피
    case hkd = "HKD" // 홍콩 달러
    case sgd = "SGD" // 싱가포르 달러
    case thb = "THB" // 태국 바트
    case myr = "MYR" // 말레이시아 링깃
    case php = "PHP" // 필리핀 페소
    case twd = "TWD" // 대만 달러
    case sek = "SEK" // 스웨덴 크로나
    case dkk = "DKK" // 덴마크 크로네
    case nok = "NOK" // 노르웨이 크로네
    case brl = "BRL" // 브라질 헤알
    case mxn = "MXN" // 멕시코 페소
    case rub = "RUB" // 러시아 루블
    case zar = "ZAR" // 남아프리카공화국 랜드
    case vnd = "VND" // 베트남 동
    case idr = "IDR" // 인도네시아 루피아
    case pln = "PLN" // 폴란드 즈워티
    case huf = "HUF" // 헝가리 포린트
    case czk = "CZK" // 체코 코루나
    case try_ = "TRY" // 터키 리라
    case aed = "AED" // 아랍에미리트 디르함
    case sar = "SAR" // 사우디 리얄
    case egp = "EGP" // 이집트 파운드
    case ils = "ILS" // 이스라엘 세켈
    case lkr = "LKR" // 스리랑카 루피
    case bdt = "BDT" // 방글라데시 타카
    case npr = "NPR" // 네팔 루피
    case mmk = "MMK" // 미얀마 짯
    case khr = "KHR" // 캄보디아 리엘
    case uzs = "UZS" // 우즈베키스탄 숨
    case uah = "UAH" // 우크라이나 흐리브냐
    case ars = "ARS" // 아르헨티나 페소
    case clp = "CLP" // 칠레 페소
    case pen = "PEN" // 페루 솔
    case dop = "DOP" // 도미니카 페소
    case lak = "LAK" // 라오스 킵
}

extension FiatCurrency {
    var country: Country {
        switch self {
        case .usd: return .US
        case .krw: return .KR
        case .eur: return .EU
        case .jpy: return .JP
        case .gbp: return .GB
        case .cny: return .CN
        case .aud: return .AU
        case .cad: return .CA
        case .chf: return .CH
        case .inr: return .IN
        case .hkd: return .HK
        case .sgd: return .SG
        case .thb: return .TH
        case .myr: return .MY
        case .php: return .PH
        case .twd: return .TW
        case .sek: return .SE
        case .dkk: return .DK
        case .nok: return .NO
        case .brl: return .BR
        case .mxn: return .MX
        case .rub: return .RU
        case .zar: return .ZA
        case .vnd: return .VN
        case .idr: return .ID
        case .pln: return .PL
        case .huf: return .HU
        case .czk: return .CZ
        case .try_: return .TR
        case .aed: return .AE
        case .sar: return .SA
        case .egp: return .EG
        case .ils: return .IL
        case .lkr: return .LK
        case .bdt: return .BD
        case .npr: return .NP
        case .mmk: return .MM
        case .khr: return .KH
        case .uzs: return .UZ
        case .uah: return .UA
        case .ars: return .AR
        case .clp: return .CL
        case .pen: return .PE
        case .dop: return .DO
        case .lak: return .LA
        }
    }

    static let countryCurrencyMap: [String: String] = [
        "TTD": "TT", // 트리니다드 달러
        "SLL": "SL", // 시에라리온 리온
        "SAR": "SA", // 사우디 아라비아 리얄
        "PGK": "PG", // 파푸아뉴기니 키나
        "PYG": "PY", // 파라과이 과라니
        "CAD": "CA", // 캐나다 달러
        "ILS": "IL", // 이스라엘 세켈
        "JPY": "JP", // 일본 엔
        "PKR": "PK", // 파키스탄 루피
        "LYD": "LY", // 리비아 디나르
        "BDT": "BD", // 방글라데시 타카
        "MOP": "MO", // 마카오 파타카
        "AZN": "AZ", // 아제르바이잔 마나트
        "NGN": "NG", // 나이지리아 나이라
        "BHD": "BH", // 바레인 디나르
        "NAD": "NA", // 나미비아 달러
        "MKD": "MK", // 북마케도니아 디나르
        "UAH": "UA", // 우크라이나 흐리브냐
        "ALL": "AL", // 알바니아 레크
        "PLN": "PL", // 폴란드 즈워티
        "HTG": "HT", // 아이티 구르드
        "LKR": "LK", // 스리랑카 루피
        "ZWD": "ZW", // 짐바브웨 달러
        "UGX": "UG", // 우간다 실링
        "GBP": "GB", // 영국 파운드
        "GYD": "GY", // 가이아나 달러
        "AMD": "AM", // 아르메니아 드람
        "AFN": "AF", // 아프가니스탄 아프가니
        "GEL": "GE", // 조지아 라리
        "UYU": "UY", // 우루과이 페소
        "KYD": "KY", // 케이맨 제도 달러
        "VND": "VN", // 베트남 동
        "AWG": "AW", // 아루바 플로린
        "YER": "YE", // 예멘 리알
        "DKK": "DK", // 덴마크 크로네
        "FJD": "FJ", // 피지 달러
        "FKP": "FK", // 포클랜드 제도 파운드
        "ARS": "AR", // 아르헨티나 페소
        "SHP": "SH", // 세인트헬레나 파운드
        "KZT": "KZ", // 카자흐스탄 텡게
        "TJS": "TJ", // 타지키스탄 소모니
        "CHF": "CH", // 스위스 프랑
        "PAB": "PA", // 파나마 발보아
        "AOA": "AO", // 앙골라 콴자
        "UZS": "UZ", // 우즈베키스탄 숨
        "STN": "ST", // 상투메 도브라
        "KES": "KE", // 케냐 실링
        "ZMK": "ZM", // 잠비아 콰차 (구화폐)
        "TRY": "TR", // 터키 리라
        "RON": "RO", // 루마니아 레우
        "IDR": "ID", // 인도네시아 루피아
        "XOF": "SN", // CFA 프랑 (서아프리카)
        "XPF": "PF", // CFP 프랑 (프랑스령 폴리네시아 등)
        "SEK": "SE", // 스웨덴 크로나
        "NPR": "NP", // 네팔 루피
        "BRL": "BR", // 브라질 헤알
        "JMD": "JM", // 자메이카 달러
        "MXN": "MX", // 멕시코 페소
        "ZAR": "ZA", // 남아프리카 랜드
        "LBP": "LB", // 레바논 파운드
        "USD": "US", // 미국 달러
        "CZK": "CZ", // 체코 코루나
        "THB": "TH", // 태국 바트
        "SRD": "SR", // 수리남 달러
        "CNY": "CN", // 중국 위안
        "EGP": "EG", // 이집트 파운드
        "BND": "BN", // 브루나이 달러
        "BSD": "BS", // 바하마 달러
        "SGD": "SG", // 싱가포르 달러
        "MAD": "MA", // 모로코 디르함
        "HKD": "HK", // 홍콩 달러
        "MYR": "MY", // 말레이시아 링깃
        "TWD": "TW", // 대만 달러
        "PHP": "PH", // 필리핀 페소
        "NOK": "NO", // 노르웨이 크로네
        "EUR": "EU", // 유로 (유럽연합)
        "INR": "IN", // 인도 루피
        "DOP": "DO", // 도미니카 페소
        "HUF": "HU", // 헝가리 포린트
        "KRW": "KR"  // 대한민국 원
    ]
}
