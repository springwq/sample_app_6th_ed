Feature: Users
  Background:
    Given I am logged in as an activated user

  Scenario: User can create micropost
    When I go to home page
    Then I should see "Compose new micropost" textare
    When I create a new micropost
    Then I should see the new micropost from "Micropost Feed"
