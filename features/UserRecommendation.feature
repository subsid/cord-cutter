Feature: User Scenarios
  
  As a user
  I want to cut the cord
  So that I can have the channels I need by being frugal
  
Background: User Page
  Given I am on the signin page
  And I follow "Sign in with Google"
  Then I am on the user home page

  Given the following channels exist:
  | name        | category          |
  | Sun TV      |  Entertainment    |
  | KTV         |  Movies           |
  | Adithya TV  |  Other            |
  | Vijay TV    |  Entertainment    |
  | Chutti TV   |  Other            |
  | CNN         |  Other            |
  | NDTV        |  Other            |
  | Jaya News   |  Other            |

  Given the following packages exist:
  | name        | cost | channels                                           |
  | Sun Network |  50  | Sun TV,Adithya TV,KTV,Vijay TV,Chutti TV           |
  | Jaya Network|  40  | Jaya TV,Jaya News,Vijay TV                         |
  | Star Network|  70  | Star Sports 1,Star Sports 2,Star Sports 3,Vijay TV |
  | HuiSports   |  30  | Star Sports 1,Star Sports 2,Star Sports 3          |
  | HuiNews     |  20  | Jaya News,NDTV,CNN                                 |
  | CheapNews   |  10  | NDTV,CNN                                           |
  
Scenario: Get Sun Network
  When I go with "Sun TV, KTV" from Must have channels
  And I fill in "Budget" with "50"
  And I press "Get Recommendations"
  Then I should see "Sun Network"
  
Scenario: News
  When I go with "NDTV, CNN, Jaya News" from Must have channels
  And I fill in "Budget" with "20"
  And I press "Get Recommendations"
  Then I should see "HuiNews"
  