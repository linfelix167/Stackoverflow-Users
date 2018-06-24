# Stackoverflow-Users

## Functional Requirements

- You will need to connect to [Stackoverflow Users API Endpoint](https://api.stackexchange.com/2.2/users?site=stackoverflow) and retrieve the first page of data. [FULL API documentation](https://api.stackexchange.com/docs)
- Display the retrieved data through a TableView.
- We expect from you to display at least username, badges and gravatar for every user.
- While the gravatar is being downloaded, the UI should show a loading animation.
- Each of the photos should be downloaded only once and stored for offline usage.
- The UI should always be responsive.

### Prerequisites

```
Xcode 9.4
```

## Built With
* [SDWebImage](https://github.com/rs/SDWebImage) - Asynchronous image downloader with cache support as a UIImageView category

## Authors
* **Felix Lin** - *Initial work* - [linfelix167](https://github.com/linfelix167)
