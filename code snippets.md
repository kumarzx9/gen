# snippets swift

### vc xib
```swift
SecondViewController(nibName: "SecondViewController", bundle: nil)
```

```swift
let viewModel = UserViewModel(url: "https://api.example.com/user/customInit")
        let vc = ExperimentalStoryBoardVC(viewModel: viewModel)
```
###  table collection
```swift
        tblVw.register(UINib(nibName: "SecTableViewCell", bundle: nil), forCellReuseIdentifier: "SecTableViewCell")
```

### add target 

```swift
@objc func <#ActionName#>(sender: UIButton) {
    print(sender.tag)
}
cell?.<#ButtonName#>.addTarget(self, action: #selector(<#ActionName#>(sender:)), for: .touchUpInside)
cell?.<#ButtonName#>.tag = indexPath.row
```
