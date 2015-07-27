module TestFactories

  include Warden::Test::Helpers
  Warden.test_mode!

  def authenticated_user(options={})
    user_options = { name:     "user#{(rand*1000).to_i}",
                     email:    "email#{(rand*1000).to_i}@fake.com",
                     password: 'helloworld',
                     role:     :free }.merge(options)

    user = User.new(user_options)
    user.skip_confirmation!
    user.save!
    user
  end
end