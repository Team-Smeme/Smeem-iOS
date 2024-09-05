# Smeem iOS

<img width="908" alt="image" src="https://github.com/Team-Smeme/Smeme-server-renewal/assets/55437339/d375dc1c-abb0-4e2e-a6e5-aad074913114">

<br/><br/>

- ✍️ **서비스 소개**: [서비스 소개 바로가기](https://linktr.ee/smeem)
- 📱 **iOS 다운로드**: [App Stroe 바로가기](https://apps.apple.com/kr/app/smeem-%EC%8A%A4%EB%B0%88-%EC%98%81%EC%9E%91-%EC%98%81%EC%96%B4%EC%9D%BC%EA%B8%B0-%EC%98%81%EC%96%B4%EB%85%B8%ED%8A%B8/id6450711685)
- 📱 **Android 다운로드**: [App Stroe 바로가기](https://play.google.com/store/apps/details?id=com.sopt.smeem)

<br/>

## 🧑‍💻 팀원 소개 (Team)

| [황찬미](https://github.com/cchanmi) | [백준](https://github.com/joonBaek12) |
| --- | --- |
| <img width="250" alt="image" src="https://github.com/Team-Smeme/Smeem-iOS/assets/86944161/44830ea7-faac-4dcd-a778-0c49d3eb7c7a" /> | <img width="250" alt="image" src="https://github.com/Team-Smeme/Smeem-iOS/assets/86944161/0e0cfcb6-d4d7-41f7-9eb0-7f516480939c" /> |
| iOS Lead Developer | iOS Developer |
| - 프로젝트 구조 설계 / 리팩토링<br/>- 스플래시, 온보딩, 마이페이지 뷰 구현<br/> | - 프로젝트 구조 설계 / 리팩토링<br/>- 홈, 일기 작성, 상세 일기 뷰 구현 |

<br/>

## ⚒️ 개발 환경
- iOS 15.0 +
- Xcode 15.0

<br/>

## ✔️ 사용 기술 & 라이브러리
- UIKit
- Combine
- Moya
- Firebase
- KakaoOpenSDK
- Kingfisher
- Snapkit

<br/>

## 🗂️ Skills

### MVVM Pattern

<img width="632" alt="스크린샷 2024-04-11 오후 8 39 12" src="https://github.com/Team-Smeme/Smeem-iOS/assets/86944161/13946768-5b6b-4273-959b-a0af4835c581">

- MVVM 패턴으로 UI와 비지니스 로직을 분리합니다.
- ViewModel의 Input과 Output 구조를 통해 데이터 흐름을 이해하기 쉽습니다.

<br/>

### Combine

- Combine Framework를 사용하여 반응형 프로그래밍을 구현합니다.
- 비동기 작업들을 집중화하고 코드를 직관적으로 관리합니다.

<br/>

### Unit Test Code

- 기능 개발 후, 테스트 코드를 작성하여 code coverage 80% 이상을 목표로 합니다.

<br/>

### DesignSystem & Custom UI

- 프로젝트 시작 전 DesignSystem 환경을 구축하여 상수화된 컬러, 폰트, 이미지에 편하게 접근합니다.
- 여러 화면에서 공통적으로 사용되는 UI들을 별도로 Custom Class로 정의하여서 코드의 재사용성을 높였습니다.

<br/>

## 🚀 Trouble Shooting
### 1) UIKit+Combine 환경에서 CollectionView 바인딩 문제
ViewModel로부터 관찰한 데이터를 sink 클로저 안에서 CollectionView에 바인딩을 해야 했습니다.
```swift
output.totalHasMyPlanResult
    .receive(on: DispatchQueue.main)
    .sink { [weak self] response in
        print("collectionView에 바인딩 될 데이터: ", response)
    }
    .store(in: &cancelBag)
````
MVVM 원칙에 따라 View가 Data를 알 필요가 없었기 때문에, 해당 데이터를 전역으로 추가하여 외부 CollectionViewDatasource 메서드에서 바인딩 할 수 없었던 상황이었습니다.

생각나는 방안으로는 2가지가 있었습니다.
1) CollectionViewDiffableDatasource를 사용하기
2) 직접 CollectionViewDatasource를 구현하기

```swift
func setUpDataSource() {
    dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, card) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExampleCell", for: indexPath) as! ExampleCell
        return cell
    })
}
````
1번 방법을 사용하면 cellProvider 클로저를 통해 collectionView의 cell에 접근할 수 있었지만, 현재 뷰에서는 데이터의 변동이 없고, 다이나믹한 애니메이션 처리가 필요하지 않았기 때문에 DiffableDatasource를 도입할 필요는 없다고 생각했습니다.

그런 이유로 2번 방법으로 택했고, 직접 CollectionViewDatasource 구현하여 바인딩을 해 주어 해결했습니다.
전역으로 해당 CollectionViewDatasource를 선언만 해 두고, sink 클로저 내에서 해당 CollectionView에 맞는 데이터를 초기화 시에 주입해 주었습니다.

```swift
// 전역으로 선언
private var mySmeemDataSource: MySmeemCollectionViewDataSource!

output.totalHasMyPlanResult
    .receive(on: DispatchQueue.main)
    .sink { [weak self] response in
        self?.mySmeemDataSource = MySmeemCollectionViewDataSource(numberItems: response.mySummaryNumber,
                                                                  textItems: response.mySumamryText)
        self?.mySmeemCollectionView.dataSource = self?.mySmeemDataSource
        self?.mySmeemCollectionView.reloadData()
    }
    .store(in: &cancelBag)
````

### 아쉬운점
1. Datasource가 데이터를 알게 되는 상황
   
Datasource 초기화 시에 데이터를 주입해 준 이후 바인딩은 collectionView 메서드에서 일어나기 때문에, 전역으로 데이터를 가지고 있어야 하는 상황이 발생했습니다.
MVVM 원칙을 따르기 위해 해당 방안을 도입한 것이었는데, 결국에은 ViewController가 아닌 Datasource가 데이터의 책임에 갖게 되어서 아쉬움이 남았습니다.
꼭 다이나믹한 데이터 바인딩이나 애니메이션 처리가 중요한 상황이 아니더라도, MVVM 원칙을 지키기 위해 DiffableDatasource를 도입하는 것도 하나의 이유가 될 수 있겠다는 생각이 들었습니다.
```swift
final class MySmeemCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    private let numberItems: [Int]
    private let textItems: [String]
    
    init(numberItems: [Int], textItems: [String]) {
        self.numberItems = numberItems
        self.textItems = textItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellType: MySmeemCollectionViewCell.self, indexPath: indexPath)
        cell.setNumberData(number: self.numberItems[indexPath.item])
        cell.setTextData(text: self.textItems[indexPath.item])
        return cell
    }
}
````
