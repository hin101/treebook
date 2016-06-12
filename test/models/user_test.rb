require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "a user should enter a first name" do
	user = User.new
	assert !user.save  	
	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
	user = User.new
	assert !user.save  	
	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
	user = User.new
	assert !user.save  	
	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
  	user = User.new
  	user.profile_name = users(:hinesh).profile_name

  	users(:hinesh)
	assert !user.save  	
	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  	user = User.new(first_name: 'Hinesh', last_name: 'Patel', email: 'test@test.com')
    user.password = user.password_confirmation = 'edgware'
    
    user.profile_name = 'hin 101'

  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formatted correctly")
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: 'Hinesh', last_name: 'Patel', email: 'test@test.com')
    user.password = user.password_confirmation = 'edgware'
    
    user.profile_name = 'hin_101'
    assert user.valid?
  end

end
