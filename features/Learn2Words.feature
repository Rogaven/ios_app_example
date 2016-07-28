Feature: Learning

Scenario: Learn two words
  Given the app has launched
  And words list was loaded
  When I select cell "Adventurous"
  And I select cell "Ambitious"
  Then something should happen
