# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env == 'development'
  
  delete = User.all
  delete.destroy_all

  #delete = Group.all
  #delete.destroy_all

  group_user = User.create(name: "ユーザー1", email: "1@1",password_digest: "1@1")

  (2..10).each do |i|
    User.create(name: "ユーザー#{i}", email: "#{i}@#{i}",password_digest: "#{i}@#{i}")
  end

end