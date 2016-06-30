require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  test 'create an address with no province' do
    address = Address.new do |a|
      a.line1 = '2737 E Pender St'
      a.city = 'Vancouver'
      a.postal_code = 'V5K 2B9'
    end

    assert address.valid?, 'address not valid'
    assert address.save, 'address could not be saved'
  end
end
