# Smeem iOS

<img width="908" alt="image" src="https://github.com/Team-Smeme/Smeme-server-renewal/assets/55437339/d375dc1c-abb0-4e2e-a6e5-aad074913114">

<br/><br/>

- ✍️ **서비스 소개**: [서비스 소개 바로가기](https://linktr.ee/smeem)
- 📱 **iOS 다운로드**: [App Stroe 바로가기](https://apps.apple.com/kr/app/smeem-%EC%8A%A4%EB%B0%88-%EC%98%81%EC%9E%91-%EC%98%81%EC%96%B4%EC%9D%BC%EA%B8%B0-%EC%98%81%EC%96%B4%EB%85%B8%ED%8A%B8/id6450711685)
- 📱 **Android 다운로드**: [App Stroe 바로가기](https://play.google.com/store/apps/details?id=com.sopt.smeem)

<br/>

## 프로젝트 기간
- **[Smeem Trouble Shooting 보러 가기](#🚀Trouble-Shooting)** <br>
- **[Smeem 운영 서비스 개선 경험 보러 가기](#✨운영-중-서비스-개선-경험)** <br>
- **[Smeem Test Code](#💡Test-Code)** <br>
- **[Smeem 프로젝트 소개](#⭐️프로젝트-소개)** <br>

## 🧑‍💻 팀원 소개 (Team)

| [황찬미](https://github.com/cchanmi) | [백준](https://github.com/joonBaek12) |
| --- | --- |
| <img width="250" alt="image" src="https://github.com/Team-Smeme/Smeem-iOS/assets/86944161/44830ea7-faac-4dcd-a778-0c49d3eb7c7a" /> | <img width="250" alt="image" src="https://github.com/Team-Smeme/Smeem-iOS/assets/86944161/0e0cfcb6-d4d7-41f7-9eb0-7f516480939c" /> |
| iOS Lead Developer | iOS Developer |
| - 프로젝트 구조 설계 / 리팩토링<br/>- 스플래시, 온보딩, 마이페이지 뷰 구현<br/> | - 프로젝트 구조 설계 / 리팩토링<br/>- 홈, 일기 작성, 상세 일기 뷰 구현 |

<br/>

# 🚀 Trouble Shooting
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
<br/>

### 2) TextView Responder 권한이 남아 있어 Keyboard 감지 Notification이 중복 호출 되는 이슈
TextView 클릭시 키보드가 활성화 및 비활성화 되면서 키보드 높이 만큼 화면을 이동시켜야 했고, 탈퇴버튼 클릭시 키보드를 감지하는 notification이 중복 호출되면서 두 배 이상의 키보드 높이 크기가 이동되는 버그가 발생했습니다.

![Simulator Screen Recording - iPhone 13 mini-16 - 2024-08-04 at 13 58 23](https://github.com/user-attachments/assets/41c67ec5-8acd-4d26-a126-b7886c5e7c73)

break point를 찍어 보았을 때, 키보드가 사라지는 걸 감지하는 notification, 올라오는 걸 감지하는 notification가 여러 번 호출되는 것을 알 수 있었습니다.
textView에 대한 responder 권한은 becomeFirstResponder, resignFirstResponder 메서드를 통해 제어하고 있었는데, 이 과정에서 문제가 발생했다고 판단했습니다.
```swift
output.notEnabledButtonResult
    .sink { [weak self] type in
        self?.resignButton.changeButtonType(buttonType: type)
        self?.summaryTextView.becomeFirstResponder()
    }
    .store(in: &cancelBag)
````

### TextView에 Responder 권한이 계속해서 남아 있었던 상태
원인은 TextView 활성화시 becomeFirstResponder 메서드를 호출하여 TextView에 Responder 권한을 준 상태지만, 이후 Responder 권한을 해지하는 코드를 작성해 주지 않은 것이었습니다.
resignResponder 메서드를 호출하지 않아도 버튼 클릭시 키보드가 자동으로 내려갔기 때문에 놓쳤던 부분이었고, 그렇다면 왜 키보드가 자동으로 비활성화 되었는지에 대해 고민했습니다.

이유는 버튼 클릭시 차례대로
1. UIAlertController 팝업이 불러와지고
2. Alert 버튼 클릭 후, 삭제 API가 호출이 되면서 초기 화면으로 보내는 과정에서 UIApplication 객체에 접근하기 때문이었습니다.

즉, TextView의 Responder 권한이 UIAlert과 UIApplication으로 잠시 넘어가는 것이었습니다.

```swift
// alert 창이 뜨는 버튼 액션
resignButton.tapPublisher
    .sink { [weak self] _ in
        print("탈퇴 버튼 클릭!")
        
        let alert = UIAlertController(title: "계정을 삭제하시겠습니까?", message: "이전에 작성했던 일기는 모두 사라집니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self?.resignButtonTapped.send(())
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        self?.present(alert, animated: true, completion: nil)
    }
    .store(in: &cancelBag)
````
```swift
// 탈퇴 성공 후, 초기 화면으로 보내는 과정에서 UIApplication 객체에 접근
func changeRootViewController(_ viewController: UIViewController) {
    guard let window = UIApplication.shared.windows.first else { return }
    UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
        let rootVC = UINavigationController(rootViewController: viewController)
        window.rootViewController = rootVC
    })
}
````
탈퇴 버튼 클릭시, UIAlertController가 표시되면서 TextView가 가지고 있던 first responder 소유권을 포기하게 됩니다. 그로인해 resign 코드를 추가해 주지 않아도 자연스럽게 키보드가 비활성화되는 모습을 볼 수 있지만, Alert 버튼을 클릭 후에 Alert창이 사라질 때, TextView에게 다시 first responder 소유권이 돌아가기 때문에 키보드가 다시 활성화되는 것을 알 수 있었습니다. 또한, API 통신 후 홈 화면으로 루트 뷰를 바꿔 주는 과정에서 UIApplication 객체에 접근하는 코드로인해 TextView의 first responder 소유권이 다시금 빼앗기게 되면서 또 다시 키보드가 비활성화되는 과정을 겪는 것을 알게 되었습니다.

사실상 UI적으로만 TextView가 잠시 내려간다는 것이고, Responder를 resign을 하지는 않았기 때문에 다른 이벤트 처리를 끝내고 나면 다시금 TextView로 Responder 소유권이 돌아온다는 것을 알 수 있었고, 그로인해 계속해서 키보드가 활성화되는 notification이 중첩되어 호출되는 것을 알 수 있었습니다.

### 해결하기 위해서는 alert 창이 뜨기 전에 직접 TextView의 Responder 권한을 해지해 주기
```swift
resignButton.tapPublisher
    .handleEvents(receiveOutput: {[weak self] _ in
        self?.summaryTextView.resignFirstResponder()
    })
    .sink { [weak self] _ in
        print("탈퇴 버튼 클릭!")
        
        let alert = UIAlertController(title: "계정을 삭제하시겠습니까?", message: "이전에 작성했던 일기는 모두 사라집니다.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in }
        let delete = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self?.resignButtonTapped.send(())
        }
        alert.addAction(cancel)
        alert.addAction(delete)
        self?.present(alert, animated: true, completion: nil)
    }
    .store(in: &cancelBag)
````
탈퇴하기 버튼이 tap 되었을 때, 해당 이벤트를 감지하고 결과를 받기 전에 handlerEvents operator를 사용하여 textView의 소유권을 직접 resign 해 주는 코드를 추가하였습니다.
그로인해 Alert 창이 뜨고 사라져도 responder의 권한이 다시 textView로 넘어가지 않게 되었습니다.

![Simulator Screen Recording - iPhone 13 mini-16 - 2024-08-04 at 17 49 42](https://github.com/user-attachments/assets/704a8280-309c-44e3-b97b-2d76ee7dedbe)
<br/>

# ✨ 운영 중 서비스 개선 경험
### 1) 운영 서비스에서 에러 발생 시 앱 멈춰 버리는 현상 개선
운영 서비스에서 에러가 발생했을 때, 그에 따른 에러 핸들링이 제대로 구축되어 있지 않아서 서비스가 그대로 묵묵부담으로 멈춰 버리는 현상이 발생했었습니다. 팀 내에서 앱이 멈춰버리는 현상을 유저에게 노출시켜서는 안된다는 의견이 나왔고, 의논 끝에 세 가지 에러 상황을 정의해 두고 해당 케이스에 맞는 토스트 메시지를 보여 주고 재시도를 요청하는 기능을 추가하게 되었습니다.

Smeem 서비스가 정의 내린 에러 상황은 세 가지입니다.
- 시스템 에러 (클라이언트 에러)
- 데이터 에러 (서버 에러)
- 네트워크 연결 실패 (유저 에러)

서버에서 내려오는 statusCode를 통해 세 가지 에러 상황을 분기해 주는 메서드를 구현했습니다.
```swift
final class NetworkManager {
    static func statusCodeErrorHandling(statusCode: Int) throws {
        switch statusCode {
        case 400..<500:
            throw SmeemError.clientError
        case 500...:
            throw SmeemError.serverError
        default:
            return
        }
    }
}
````

서버 통신 후,매핑이 잘못되는 상황에는 client error, 서버 통신 자체는 성공했지만 서버에서 에러가 발생했을 경우 catch문으로 error를, case .failure은 서버 통신, 실패 유무를 떠나서 네트워크 연결 자체가 안 되어 있는 상황이기 때문에 서비스 요구사항에 맞게 .userError 타입을 보내도록 구현했습니다.
```swift
case .success(let response):
    do {
        try NetworkManager.statusCodeErrorHandling(statusCode: response.statusCode)
        guard let data = try? response.map(GeneralResponse<MySummaryResponse>.self).data else {
            throw SmeemError.clientError
        }
        completion(.success(data))
    } catch let error {
        guard let error = error as? SmeemError else { return }
        completion(.failure(error))
    }
case .failure(_):
    completion(.failure(.userError))
}
````
ViewModel에서 서버 통신 후, 에러가 발생했을 경우 errorSubject로 값을 흘려보내 주고, View에서는 errorSubject를 관찰하고 있다가 어떤 에러인지 알 필요 없이 그저 전달받은 에러 타입을 토스트 메시지로 띄워 주는 행위에만 집중할 수 있도록 View와 ViewModel의 역할을 분리하여 구현했습니다.
```swift
output.errorResult
    .receive(on: DispatchQueue.main)
    .sink { [weak self] error in
        self?.showToast(toastType: .smeemErrorToast(message: error))
    }
    .store(in: &cancelBag)
````
<br/>

![img](https://github.com/user-attachments/assets/23a9e49d-7603-4ed7-b775-8c7dea0c43aa)

만약 에러가 발생한다면 위와 같이 토스트 메시지를 통해 유저에게 재접속을 요청하게 되고, 유저에게 보다 더 친절한 UI를 제공하도록 개선할 수 있었습니다.

<br/>

### 2) 토큰 만료 플로우 개선 경험
운영 서비스에서 앱 시작 전 스플래시 화면에서 에러가 발생하여 사용자들이 앱에 진입할 수 없는 문제가 발생했습니다. 해당 오류는 모든 유저한테서 공통적으로 발생하는 에러는 아니었기 때문에 원인 파악이 쉽지 않았습니다.

![img (1)](https://github.com/user-attachments/assets/71c21263-41b7-42ed-bad2-52a3f63a4024)

유저가 스플래시 뷰에서 다음 화면으로 넘어가지 못하고 앱이 멈추는 현상은 크리티컬한 현상이었기 때문에, 원인을 찾고자 팀원들에게 스플래시 화면에서 호출되고 있는 API response들의 문서를 요청하였습니다.

![image](https://github.com/user-attachments/assets/16e37ac8-c8c9-4ff5-825a-1f56016a987d)

서버에서 보내 줄 수 있는 에러 응답 문서화를 보다가 401일 경우, 토큰이 만료되었을 에러 케이스를 발견할 수 있었고 현재 상황의 원인일 것이라고 생각했습니다.

Smeem 서비스는 소셜로그인을 통해 로그인을 성공한 유저일 경우, 서버로부터 access, refresh 토큰을 응답값으로 받게 됩니다. 모든 API 통신은 access를 헤더에 담아 요청을 해 왔으며, access의 만료 시간이 짧다는 점을 감안하여서 스플래시 화면 진입시 서버로부터 토큰을 재발급 받는 API를 호출하도록 구현해 놓았습니다.
access와 다르게 refresh는 만료 시간이 더 길었으며, 스플래시 화면 진입 시 refresh 토큰을 통해 access를 재발급받고, 기존 access 토큰을 재발급받은 토큰으로 갱신해 주는 로직으로 구현이 되어 있었습니다.

사진으로 표현하자면 이러한 플로우였습니다.

![image](https://github.com/user-attachments/assets/22d6a836-be05-4dc8-b457-2e4ed43f818a)

출처 : https://www.rfc-editor.org/rfc/rfc6749.html

하지만 여기서 간과한 점은 refresh가 만료되었을 경우의 처리를 놓쳤다는 것이었습니다. Smeem 프로젝트는 access는 2시간, refresh는 2주로 만료 시간이 정해져 있었고, 2주가 지난 시점부터 refresh 토큰이 만료되었을 때, 토큰 재발급이 불가능해지고 그로인해 서버에서 401 토큰 만료 에러를 던져 주게 되는데 그에 따른 예외 처리가 제대로 되어 있지 않았습니다. 또한 앱을 다운로드한 후 2주 동안 앱이 진입하지 않았다가 이후에 앱에 진입한 특정 유저들에게서만 발생하는 에러였다는 결론에 도달했습니다.

초반 설계의 중요성을 깨달았고, 토큰이 왜 access, refresh 두 개로 나뉘어져 있는지 만료가 되었을 때 클라이언트 개발자로서 어떠한 역할을 해 주어야 하는지 등 의문을 더 많이 가지고 접근했으면 방지할 수 있었을 에러였던 것 같아서 아쉬움을 느꼈습니다.

해당 문제는 refresh 토큰까지 만료되었을 경우, 사용자는 다시 새로운 토큰을 발급 받아야 하기 때문에 사용자를 시작 화면으로 보내 주는 플로우를 추가하여 해결할 수 있었습니다.
기존 코드에서는 에러 발생 시, 토스트 메시지만 띄워 주고 그대로 앱이 멈췄지만, restartSubject라는 publisher를 추가하여서 에러 발생시 시작 화면으로 보내 주는 플로우를 추가했습니다.

```swift
output.errorResult
    .receive(on: DispatchQueue.main)
    .sink { [weak self] error in
        self?.showToast(toastType: .smeemErrorToast(message: error))
        self?.restartSubject.send(())
    }
    .store(in: &cancelBag)
````

![img (2)](https://github.com/user-attachments/assets/d34ce6b8-9dac-45a3-ad54-79b1ddfd4cc3)

<br/>

# 💡 Test Code
### Test Code 목표
- Code Coverage 80% 이상 목표
<img width="1102" alt="스크린샷 2024-09-06 오후 2 16 50" src="https://github.com/user-attachments/assets/ef299274-5d56-4d7d-aa1b-feb823d08f35">
<img width="1100" alt="스크린샷 2024-09-06 오후 2 17 33" src="https://github.com/user-attachments/assets/636a73bf-32ae-4534-8f57-c6c59547981c">
<img width="1104" alt="스크린샷 2024-09-06 오후 2 17 58" src="https://github.com/user-attachments/assets/4c8f37ea-e053-47bc-85bb-a7e9653fa72b">

<br/>

- Smeem Test Code 원칙
1) 각각의 Endpoint는 typealias를 사용하여 TargetEndPoint라는 네이밍으로 통일
2) 전역으로 사용할 객체를 정의해 두고, setUpWithError() 메서드에서 초기화
3) 메서드 네이밍은 test_테스트할행동_결과 ex) test_닉네임중복검사API_성공했을때
4) Given, When, Then 주석 사용

<br/>

Smeem에서는 총 2가지 경우를 Test 했습니다.
1) 네트워크 통신이 일어나는 Service Test
2) ViewModel 로직 검증 Test

### Moya를 이용한 Network Test Code
관련 PR: https://github.com/Team-Smeme/Smeem-iOS/pull/177

서버 통신시 Mock 객체를 이용하기 위해 서버 통신을 요청하는 provider 객체를 기존 싱글톤 패턴에서 의존성주입으로 리팩토링하였습니다.

```swift
var provider: MoyaProvider<OnboardingEndPoint>!

init(provider: MoyaProvider<OnboardingEndPoint> = MoyaProvider<OnboardingEndPoint>()) {
    self.provider = provider
}
````

Moya BaseTarget의 프로퍼티인 sampleData에 원하는 형식의 JSON 데이터를 입력하고, Moya에서 제공하는 stub closure를 사용하여 서버 통신에 성공한 경우, statuscode 400, 500인 경우를 테스트했습니다.

```swift
func makeProvider() -> MoyaProvider<TargetEndPoint> {
    let endpointClosure = { (target: TargetEndPoint) -> Endpoint in
        return Endpoint(url: target.path,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }
    return MoyaProvider<TargetEndPoint>(endpointClosure: endpointClosure,
                                        stubClosure: MoyaProvider.immediatelyStub)
}
````

### ViewModel Test
원하는 Input이 들어갔을 때, 그에 맞는 Output을 도출하는지에 대한 ViewModel 로직 테스트를 진행했습니다. ViewModel에서 일어나는 서버 통신 또한, ServiceProtocol 타입을 초기화시에 주입해 주어서 테스트 환경에서 Mock으로 도입하여 진행하였습니다.

```swift
func test_공백포함열글자_잘처리하는지() {
    // Given
    let value = " 공백포함   10글자넘었을때   "
    
    // When
    var outputResult: SmeemButtonType!
    let expectedResult = SmeemButtonType.notEnabled
    
    output.textFieldResult
        .sink { type in
            outputResult = type
        }
        .store(in: &cancelBag)
    
    input.textFieldSubject.send(value)
    
    // Then
    XCTAssertEqual(outputResult, expectedResult)
}
````

<br/>

# ⭐️ 프로젝트 소개

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
