Feature: Home page
  In order to remember things
  As a user
  I want to write TODOs.

  Scenario: User visits the home page
    Given I am on the home page
    Then I should see "All TODOs | TODOs" within "title"

  Scenario: User writes a TODO message
    Given I am on the home page
    When I fill in "content" with "Remember the milk."
    And I press "Add TODO"
    Then I should see "Remember the milk."

  Scenario: User clicks [edit] link
    Given I am on the home page
    When I follow "[edit]"
    Then I should see "Edit note" within "title"
    And I should see "Remember the milk." within "textarea"
