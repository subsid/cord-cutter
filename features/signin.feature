Feature: Signing with Google
  
  As a user
  I want to signin with my Google account
  So that I want to save my preferences
  
  Scenario: Signin with google
    When I go to the home page
    Then I should see "Sign in with Google"
    
    And I follow "Sign in with Google"
    Then I am on the home page
    And I should see "Welcome abcd"
    And I should see "LOGOUT!"
    
    And I follow "LOGOUT!"
    Then I am on the home page
    And I should see "Sign in with Google"