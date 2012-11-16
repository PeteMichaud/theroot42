require 'rake'
require 'benchmark'

namespace :db do

  desc "Fill database with sample data"
  task :populate, [:magnitude] => :environment do |t, args|

  puts Benchmark.measure {

    # Enforce argument limits
    args.with_defaults(:magnitude => 500)

    magnitude = args.magnitude.to_i

    # Clear out old test data
    Rake::Task['db:schema:dump'].invoke
    Rake::Task['db:schema:load'].invoke

    #lets the progress tick update in real time
    $stdout.sync = true

    #generate

    generate_admin
    generate_users magnitude
    generate_tags 10 * magnitude
    generate_comments 100 * magnitude
    generate_votes 1000 * magnitude
  }
  end

  # Helper Methods

  def generate_user u_params, print = true
    u = User.new u_params
    u.save

    puts "#{u_params[:account_type].capitalize} Generated. Zazing!" if print

    u
  end

  def generate_admin
    generate_user(
    {
        name: "Root Administrator",
        email: "admin@theroot42.org",
        password: "letmein",
        account_type: :admin,
        location: 'Austin, TX'
    })
  end

  def generate_users user_count
    puts "Generating #{user_count} Awesome Users"
    one_percent = user_count < 100 ? 1 : (user_count / 100).to_i
    Devise.stretches = 1

    user_count.times do |n|
      name = Forgery(:name)
      addr = Forgery(:address)
      generate_user({
          email:            "user#{n}@7ey.es",
          password:         'letmein',
          name:             "#{name.first_name} #{name.last_name}",
          remember_me:      true,
          location:         "#{addr.city}, #{addr.state_abbrev}"
      }, false)
      print '.' if n % one_percent == 0
    end
    puts ''
    puts "Kapow!"
  end

  def fast_insert table, columns, count, &block
    one_percent = count < 100 ? 1 : (count / 100).to_i
    inserts = []
    time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    count.times do |n|
      inserts << "(#{yield(n)}, '#{time}', '#{time}')"
      print '.' if n % one_percent == 0
    end
    sql = "INSERT INTO #{table} (`#{columns.join('`, `')}`, `created_at`, `updated_at`) VALUES #{inserts.join(", ")}"
    puts " Size of Query: #{sql.bytesize / 1024 / 1024}M"
    ActiveRecord::Base.connection.execute(sql)
  end

  def generate_tags tag_count
    puts "Generating #{tag_count} Tubular Tags"

    fast_insert :tags, %w(name param_name), tag_count do |n|
      name = Forgery(:lorem_ipsum).words(Random.rand(1..3))
      "'#{name}','#{name.parameterize}'"
    end

    puts ''
    puts "Zing!"
  end

  def generate_comments comment_count
    puts "Generating #{comment_count} Cromulent Comments"

    user_count = User.count
    fast_insert :comments, %w(user_id content), comment_count do |n|
      "#{Random.rand(1..user_count)}, '#{Forgery(:lorem_ipsum).paragraphs(Random.rand(1..3))}'"
    end

    puts ''
    puts "Biff!"

    tag_comments
  end

  def tag_comments
    comment_count = Comment.count

    puts "Tagging #{comment_count} Capital Comments"
    one_percent = comment_count < 100 ? 1 : (comment_count / 100).to_i

    tag_count = Tag.count

    inserts = []
    time = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    (1..comment_count).each do |comment_id|
      Random.rand(1..4).times do |n|
        inserts << "(#{Random.rand(1..tag_count)}, #{comment_id}, #{n}, '#{time}', '#{time}')"
      end
      print '.' if comment_id % one_percent == 0
    end
    sql = "INSERT INTO taggings (`tag_id`, `comment_id`, `position`, `created_at`, `updated_at`) VALUES #{inserts.join(", ")}"
    puts " Size of Query: #{sql.bytesize / 1024 / 1024}M"
    ActiveRecord::Base.connection.execute(sql)

    puts ''
    puts "Zow!"
  end

  def generate_votes vote_count

    puts "Generating #{vote_count} Vivacious Votes"

    comment_count = Comment.count
    user_count = User.count

    fast_insert :votes, %w(comment_id user_id value), vote_count do |n|
      "#{Random.rand(1..comment_count)}, #{Random.rand(1..user_count)}, #{Random.rand(0..1)}"
    end

    puts ''
    puts "Kazing!"
  end

end