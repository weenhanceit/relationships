require "application_system_test_case"

class PeopleTest < ApplicationSystemTestCase
  test "add a connection" do
    visit edit_person_path(people(:connection_root))
  end
end
