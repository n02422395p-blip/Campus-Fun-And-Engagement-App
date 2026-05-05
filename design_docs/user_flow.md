# User Flow Diagram - NUST Fun Module

```mermaid
graph TD
    Start([App Launch]) --> Splash{Splash Screen}
    Splash -->|First time| Login[Login Screen]
    Splash -->|Logged in| Home[Home Screen]
    
    Login -->|Enter credentials| Auth{Authentication}
    Auth -->|Success| Home
    Auth -->|Failed| Error[Show Error]
    Error --> Login
    
    Login -->|No account| Register[Register Screen]
    Register -->|Sign up| Home
    
    Home -->|Tap Trivia card| Trivia[Trivia Screen]
    Home -->|Tap Fitness card| Fitness[Fitness Screen]
    Home -->|Tap Leaderboard| Leaderboard[Leaderboard Screen]
    Home -->|Tap Profile| Profile[Profile Screen]
    
    Trivia -->|Answer questions| Quiz{Quiz Flow}
    Quiz -->|Complete| Result[Results Screen]
    Result -->|View score| Leaderboard
    Result -->|Play again| Trivia
    Quiz -->|Back| Home
    
    Fitness -->|Complete challenge| Update{Update Progress}
    Update -->|Update streak| Streak[Show Streak Celebration]
    Update -->|Update points| Points[Show Points Earned]
    Streak --> Fitness
    Points --> Fitness
    Fitness -->|View History| History[History Screen]
    History -->|Back| Fitness
    
    Leaderboard -->|Filter| Weekly[Weekly Rankings]
    Leaderboard -->|Filter| AllTime[All Time Rankings]
    Leaderboard -->|Filter| Friends[Friends Rankings]
    
    Profile -->|Edit info| EditProfile[Edit Profile Screen]
    Profile -->|Settings| Settings[Settings Screen]
    Profile -->|Logout| Login
    Settings -->|Dark mode| Toggle{Theme Toggle}
    Settings -->|Notifications| Notif[Notification Preferences]
    
    EditProfile -->|Save| Profile
    EditProfile -->|Cancel| Profile
    
    style Home fill:#4ECDC4,stroke:#333,stroke-width:2px
    style Trivia fill:#FF6B6B,stroke:#333,stroke-width:2px
    style Fitness fill:#45B7D1,stroke:#333,stroke-width:2px
    style Leaderboard fill:#FFD700,stroke:#333,stroke-width:2px
    style Profile fill:#96CEB4,stroke:#333,stroke-width:2px