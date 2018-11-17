Feature: Signing with Google
  
  As a user
  I want to signin with my Google account
  So that I want to save my preferences
  
  Scenario: Signin and signout with google
    When I am on the signin page
    Then I should see "Sign in with Google"
    And I follow "Sign in with Google"
    Then I am on the home page
    And I should see "Stream Packages"
    And I should see "Package Name"
    And I follow "LOGOUT!"
    Then I am on the home page
    And I should see "Sign in with Google"