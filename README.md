# Giphy-App
iOS application that shows you trending GIFs. User(s) have the ability to search for GIFs by entering a query/keyword in the search bar.
<img width="463" alt="Screen Shot 2022-02-15 at 7 42 18 PM" src="https://user-images.githubusercontent.com/61053657/154180423-2e91e466-ed40-4086-b23f-ff36dd6c5ed7.png">

<img width="468" alt="Screen Shot 2022-02-15 at 7 42 58 PM" src="https://user-images.githubusercontent.com/61053657/154180449-b87a7bb7-a00b-408f-bef6-46653cd74a3b.png">

<img width="463" alt="Screen Shot 2022-02-15 at 7 44 37 PM" src="https://user-images.githubusercontent.com/61053657/154180466-29c863d8-173f-4e17-8fde-0e5fb8c36054.png">

# Prerequisites
- [Xcode](https://developer.apple.com/xcode/) - IDE to build and run the project.

# Pods Used in this Project
- [SnapKit](https://snapkit.io/docs/) - A Swift Autolayout DSL for both iOS and OS X
- [CocoaPods](https://cocoapods.org/) - A dependency manager for Swift and Objective-C Cocoa projects.

# Project Structure
The project has 2 major view controllers, `MainViewController` and `DetailViewController`. The `MainViewController` is the first screen users land on after launching the app, this contains a collection of all the GIFs downloaded from the trending GIF endpoint. It also has a search bar to enable the user search for GIFs using keywords.
The `DetailViewontroller` is the screen the user lands on after tapping/selecting a cell. It displays the selected GIF, its title, the source of the GIF and its rating (g, pg, r, etc.).

# Network Layer
This project uses the MVC design pattern.
The network layer holds a Singleton class called `NetworkManager` which habours all the methods used for making network calls/requests.
To make a network call, you simply create a reference to the Singleton in order to gain access to its methods. Below is an illustration of how to gain access to the `fetchTrendingData(rating: rating)` method in order to make the network call.

```
    func fetchData() {
        NetworkManager.shared.fetchTrendingData(rating: rating) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let trendingResponse):
                self.trendingResponse = trendingResponse.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(.invalidData):
                print("Invalid data.")
            case .failure(.unableToComplete):
                print("Unable to complete.")
            case .failure(.invalidResponse):
                print("Invalid response.")
            }
        }
    }
```

# View Layer
All views were built programmatically. All UI components like cells and labels are customized and can be reused.

# Model Layer
The model consists of 6 Codable Structs; `TrendingData`, `TrendingResponse`, `SearchData`, `SearchResponse`, `GetById`, `GetByIDResponse`

# Author
- ### Meekam Okeke

