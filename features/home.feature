Feature: Home page
  In order to write TODOs
  As a user
  I want to visit the home page.

  Scenario: User visits the home page
    Given I am on the home page
    Then I should see "All TODOs | TODOs" within "title"
