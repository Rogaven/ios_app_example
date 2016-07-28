Given(/^the app has launched$/) do
  wait_for do
    !query("*").empty?
  end
end

And(/^words list was loaded$/) do
  wait_for do
    query("* marked:'In progress'").empty?
  end

  if query("tableView","numberOfRowsInSection"=>0) == 0
    fail(msg="Empty table")
  end

  did_something = true

  unless did_something
    fail 'Expected to have done something'
  end
end

When(/^I select cell "([^"]*)"$/) do |arg1|
  touch("* marked: '#{arg1}'")
end

Then(/^something should happen$/) do
  if query("* marked: 'studying'", :accessibilityValue) != ["2"]
      puts query("* marked: 'studying'", :accessibilityValue).inspect
      fail 'Counter didn\'t increase'
  end
  touch("* marked:'Train'")
end