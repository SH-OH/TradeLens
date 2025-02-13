# TradeLens

TradeLens는 BitMEX OpenAPI를 이용해 주문장(Order Book) 데이터와 최근 거래 데이터(Recent Trades)를 실시간으로 시각화하는 간단한 iOS 앱입니다.

---

## 설치 및 실행

1. **TradeLens.xcworkspace - App scheme** 로 실행.
2. iOS 15 이상(iOS 15.2, 16.0, 18.0 등)에서 테스트 되었습니다.

---

## 주요 기능

- **실시간 주문장(Order Book) 데이터 시각화**
  - 매수/매도 데이터를 구분하여 정렬된 리스트로 표시
  - 누적 거래량 계산 및 상위 20개 데이터 표시
- **최근 거래 데이터(Recent Trades) 표시**
  - 새로운 데이터 발생 시 하이라이트 애니메이션 추가
  - 데이터 정렬 및 실시간 업데이트
- **네트워크 상태 처리**
  - 웹소켓(WebSocket) 기반 실시간 데이터 스트림
  - 연결 실패 시 자동 재시도 및 상태 관리
- **에러 처리 및 알림**
  - 에러 메시지 및 재시도 가능

---

## 기술 스택

- 언어: Swift 6.0
- UI: SwiftUI
- 비동기 처리: Combine, Swift Concurrency
- 아키텍처: Micro-Modular + Clean Architecture + MVVM
- 모듈화: SPM 모듈화
- 테스트: XCTest

---

## 추가 정보

- 모듈은 각각 하나의 도메인을 담당하도록 설계하였습니다.  
- 각 모듈은 Clean Architecture 원칙과 SRP(단일 책임 원칙)을 최대한 준수하며 설계하였습니다.
- 데이터의 일관성을 우선으로 로직을 구현하였으며, 그 외 캐싱, Backpressure, 동시성 처리 등 최적화 작업을 수행했습니다.
