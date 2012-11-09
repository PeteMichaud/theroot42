# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create({
    email: 'admin@theroot42.org',
    password: 'letmein',
    location: 'Austin, TX',
    name: 'Pete Michaud'
})

#Tag.create({tag:'test-tag'})
#Tag.create({tag:'vent'})
#Tag.create({tag:'critique'})
#Tag.create({tag:'design-talk'})
#Tag.create({tag:'wisdom'})
#Tag.create({tag:'random'})
#Tag.create({tag:'workforce'})

Comment.create({content: 'This is the comment', user_id: user.id})