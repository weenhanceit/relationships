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

  test 'person has three types of addresses' do
    a_person = Person.new(name: 'a_person')
    an_address = Address.new(city: 'home city', province: provinces(:bc))
    a_person.address_people << AddressPerson.new(address: an_address,
                                                 address_type: 'home')
    a_person.address_people << AddressPerson.new(address: an_address,
                                                 address_type: 'mailing')
    a_person.address_people << AddressPerson.new(address: an_address,
                                                 address_type: 'work')
    another_address = Address.new(city: 'work city', province: provinces(:bc))
    a_person.address_people << AddressPerson.new(address: another_address,
                                                 address_type: 'work')

    assert_difference 'Person.count' do
      assert_difference 'Address.count', 2 do
        # The associations don't start working until you save the object.
        assert a_person.save
      end
    end
    assert_equal 4, a_person.addresses.size
    assert_equal 3, a_person.address_types.size
  end

  test 'person has three types of addresses version 2' do
    a_person = Person.new(name: 'a_person')
    an_address = Address.new(city: 'home city', province: provinces(:bc))
    ap1 = AddressPerson.new(address: an_address,
                            person: a_person,
                            address_type: 'home')
    ap2 = AddressPerson.new(address: an_address,
                            person: a_person,
                            address_type: 'mailing')
    ap3 = AddressPerson.new(address: an_address,
                            person: a_person,
                            address_type: 'work')
    another_address = Address.new(city: 'work city', province: provinces(:bc))
    ap4 = AddressPerson.new(address: another_address,
                            person: a_person,
                            address_type: 'work')

    assert_difference 'Person.count' do
      assert_difference 'Address.count', 2 do
        # The associations don't start working until you save the object.
        assert ap1.save
        assert ap2.save
        assert ap3.save
        assert ap4.save
      end
    end
    assert_equal 4, a_person.addresses.size
    assert_equal 3, a_person.address_types.size
  end
end
