Feature: Admin Powers
  
  As an admin
  I want to handle stream packages
  So that users have a lot of popular choices
  
Background: Admin is logged in
  Given I am on the signin page
  And I follow "Sign in with Google"
  Then I am on the home page
  
  Given the following channels exist:
  | name        | category |
  | Sun TV      |  Other   |
  | KTV         |  Movies  |

  Given the following packages exist:
  | name        | cost |
  | Sun Network |  50  |

  Scenario: Add Stream Package and back
    When I follow "Add Stream Package"
    Then I should be on the new stream packages page
    And I follow "Back"
    Then I should be on the home page
    
  Scenario: Add Stream Package
    When I follow "Add Stream Package"
    Then I should see "New Stream Package"
    And I fill in "Name" with "ABC"
    And I fill in "Cost" with "10"
    And I go with "Sun TV, KTV" from Channels
    And I press "Create Stream package"
    Then I should see "Stream package was successfully created"
    And I am on the details page for "ABC"
    And I should see "Sun TV"
    And I should see "KTV"

  Scenario: Add Stream Package
    When I follow "Add Stream Package"
    Then I should see "New Stream Package"
    And I fill in "Name" with "ABC"
    And I fill in "Cost" with "10"
    And I press "Create Stream package"
    Then I should see "Stream package was successfully created"
    And I am on the details page for "ABC"
  
  Scenario: More Info about and back to home
    When I go to the details page for "Sun Network"
    Then I should see "Name: Sun Network"
    And I follow "Back"
    Then I should be on the home page
  
  Scenario: More Info and Edit
    When I go to the details page for "Sun Network"
    And I follow "Edit"
    Then I should be on the edit page for "Sun Network"
    And I fill in "Cost" with "500"
    And I press "Update Stream package"
    Then I should see "Stream package was successfully updated"
    And I am on the details page for "Sun Network"
    And the cost of "Sun Network" should be 500
    
  Scenario: More Info -> Edit -> Show
    cenario: More Info and Edit
    When I go to the details page for "Sun Network"
    And I follow "Edit"
    And I follow "Show"
    Then I should be on the details page for "Sun Network"
    
  Scenario: More Info -> Edit -> Back
    When I go to the details page for "Sun Network"
    And I follow "Edit"
    And I follow "Back"
    Then I should be on the home page