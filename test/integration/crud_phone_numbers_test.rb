require "test_helper"
require "capybara/poltergeist"

class CrudPhoneNumbersTest < CapybaraTestCase
  def setup
    Capybara.javascript_driver = :poltergeist
    Capybara.current_driver = Capybara.javascript_driver
    # Capybara.default_max_wait_time = 60

    # Capybara.register_driver :poltergeist do |app|
    #   # Capybara::Poltergeist::Driver.new(app, timeout: 60)
    #   Capybara::Poltergeist::Driver.new(app,
    #                                     #js_errors: false,
    #                                     ##inspector: true,
    #                                     #phantomjs_logger: Rails.logger,
    #                                     #logger: nil,
    #                                     #phantomjs_options: ['--debug=no', '--load-images=no', '--ignore-ssl-errors=yes', '--ssl-protocol=TLSv1'],
    #                                     debug: true)
    # end
  end

  test "add a person" do
    visit "/people"
    click_link "Add Person"
    # puts "Current path: #{current_path}"

    assert_equal new_person_path, current_path
    # click_link("Home")
    # assert_equal "/", current_path
    # click_link("Click Here")
    # 5.times { |_x| find_link("Click Here").trigger('click') }
    fill_in "Name", with: "Arnie Narnie"
    click_link "Add Phone"
    # find_link("Add Phone").trigger("click")
    # puts body
    assert_selector "fieldset", count: 1
    fill_in "Number", with: "999-999-9999"
    fill_in "Type", with: "Work"
    click_link "Add Phone"
    assert_selector "fieldset", count: 2
    within ".phone-numbers fieldset:last-of-type" do
      fill_in "Number", with: "888-888-8888"
      fill_in "Type", with: "Home"
    end
    assert_difference "Phone.count", 2 do
      assert_difference "Person.count" do
        click_button "Create Person"
      end
    end
    assert has_content?("999-999-9999")
    assert has_content?("888-888-8888")

    click_link "Edit"
    within ".phone-numbers fieldset:last-of-type" do
      click_link "Remove"
    end
    assert has_no_content?("999-999-9999")
    assert_difference "Phone.count", -1 do
      click_button "Update Person"
    end
  end

  test "edit from phone number" do
    visit "/phones"
    within "li:first-of-type" do
      click_link "Edit"
    end

    new_name = "New Name"
    assert has_content?("Name")
    assert has_field?("Name", with: "Has One Phone")
    fill_in "Name", with: new_name
    assert_no_difference "Phone.count" do
      assert_no_difference "Person.count" do
        click_button "Update Phone"
      end
    end

    assert Person.find_by(name: new_name), "Couldn't find Person #{new_name}"
  end

  test "edit existing" do
    visit "/people"
    within("p", text: "Has Two Phones") do
      click_link "Edit"
    end

    new_name = "New Name"
    fill_in "Name", with: new_name
    new_number = "000-000-0000"
    within("fieldset:first-of-type") do
      fill_in "Number", with: new_number
    end
    assert_no_difference "Phone.count" do
      assert_no_difference "Person.count" do
        click_button "Update Person"
      end
    end

    assert has_text?(new_name)
    assert has_text?(new_number)
  end
end
