Feature: Home Page
  # Scenario: Logged-in user should see all microposts feed
  # Scenario: Logged-in user can post micropost
  # Scenario: Logged-in user can delete owned microposts
  # Scenario: Logged-in user can click to following list page

  Scenario: Logged-in user should see all microposts feed
    When I visit home page
    Then I should not see "Micropost Feed"
    When I am logged in as an activated user
      And I visit home page
    Then I should see "Micropost Feed"
    
  Scenario: Logged-in user can post micropost
    When I visit home page
    Then I should not see "microposts"
    When I am logged in as an activated user
      And I visit home page
    Then I should see my name
    When I fill "This is a test micropost" into the "micropost[content]" field
      And I click on element "section.micropost_form > form > input.btn.btn-primary"
    Then I should see "This is a test micropost"

   Scenario: Logged-in user can delete owned microposts
    When I visit home page
    Then I should not see "Micropost Feed"
    When I am logged in as an activated user
      And I visit home page
    Then I should see my name
    When I fill "This is a test micropost" into the "micropost[content]" field
      And I click on element "section.micropost_form > form > input.btn.btn-primary"
    Then I should see "This is a test micropost"
      And I should see "delete"
    When I click on the "delete" link
    Then I should not see "This is a test micropost"

    Scenario: Logged-in user can click to following list page
      When I visit home page
      Then I should not see "Following"
      When I am logged in as an activated user
        And I visit home page
      Then I should see "following"
      When I click on element "section.stats > div > a:nth-child(1)"
      Then I should see "Following"