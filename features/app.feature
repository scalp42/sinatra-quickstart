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

  Scenario: User marks a TODO as done
    Given I am on the home page
    When I follow "done"
    Then I should see "undone"

  Scenario: User marks a TODO as undone
    Given I am on the home page
    When I follow "undone"
    Then I should not see "undone"

  Scenario: User visits edit page
    Given I am on the home page
    When I follow "[edit]"
    Then I should see "Edit note" within "title"
    And I should see "Remember the milk." within "textarea"

  Scenario: User wants to edit a TODO
    Given I am on the home page
    And I follow "[edit]"
    When I fill in "content" with "Forget the milk."
    And I press "submit"
    Then I should see "Forget the milk."

  Scenario: User visits delete page
    Given I am on the home page
    And I follow "[edit]"
    When I follow "Delete"
    Then I should see "Are you sure you want to delete the following note:"

  Scenario: User wants to delete a TODO
    Given I am on the home page
    And I follow "[edit]"
    And I follow "Delete"
    When I press "Yes, delete it!"
    Then I should not see "Forget the milk."

  Scenario: User writes a TODO message which includes HTML tags
    Given I am on the home page
    When I fill in "content" with "</article>woops <script>alert('zomg haxz');</script>"
    And I press "Add TODO"
    Then I should see "</article>woops <script>alert('zomg haxz');</script>"

