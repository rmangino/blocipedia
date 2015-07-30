# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'faker'

###############################################################################

# Helpers

def create_user(name, email, password, role)
  user = User.new(name: name, email: email, password: password, role: role)
  user.skip_confirmation!
  user.save!
end

###############################################################################

# Create Users

admin        = create_user('Admin User', 'admin@example.com', 'helloworld', :admin)
user1free    = create_user('User1Free', 'user1free@example.com', 'helloworld', :free)
user2free    = create_user('User2Free', 'user2free@example.com', 'helloworld', :free)
user1premium = create_user('User1Premium', 'user1premium@example.com', 'helloworld', :premium)
user2premium = create_user('User2Premium', 'user2premium@example.com', 'helloworld', :premium)

###############################################################################

# Create public Wikis

User.all.each do |user|
  5.times do |n|
    Wiki.create!(title: "#{user.name}'s wiki #{n+1}",
                 body: Faker::Lorem.paragraph,
                 user: user)
  end
end

###############################################################################

# Create private Wikis for users with that ability

User.all.each do |user|
  if user.can_create_private_wikis?
    2.times do |n|
      Wiki.create!(title: "#{user.name}'s wiki #{n+1} - private",
                   body: Faker::Lorem.paragraph,
                   private: true,
                   user: user)
    end
  end
end

###############################################################################

# Report results

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} topics created"
