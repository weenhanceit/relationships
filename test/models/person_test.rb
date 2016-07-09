require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test 'person has a user' do
    assert_not_nil people(:has_a_user).user
  end

  test 'person does not have a user' do
    assert_nil people(:has_no_user).user
  end

  test 'person has no addresses' do
    assert_equal 0, people(:has_no_address).addresses.size
  end

  test 'person has one address' do
    assert_equal 1, people(:has_one_address).addresses.size
  end

  test 'person has two addresses' do
    assert_equal 2, people(:has_two_addresses).addresses.size
  end
end
