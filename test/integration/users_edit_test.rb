require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:richard)
  end

  test "unsuccessful edit" do
    log_in_as @user
    get profile_path
    assert_template 'users/edit'
    patch user_path(@user), user: { name:  "",
                                    gender: "potato" }
    assert_template 'users/edit'
  end
  
  test "successful edit" do
    log_in_as @user
    get profile_path
    assert_template 'users/edit'
    name  = "Foo Bar"
    gender = "male"
    patch user_path(@user), user: { name:  name,
                                    gender: gender }
    assert_not flash.empty?
    @user.reload
    assert_equal name,  @user.name
    assert_equal gender, @user.gender
  end
end