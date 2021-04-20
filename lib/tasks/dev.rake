task sample_data: :environment do
  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Photo.destroy_all
    Like.destroy_all
    User.destroy_all
  end

  starting = Time.now

  12.times do 
    name = Faker::Name.first_name.downcase
    u = User.create(
      email: "#{name}@example.com",
      username: name,
      password: "password",
      private: [true, false].sample
    )

    # p u.errors_full_messages
  end

  users = User.all

  users.each do |first_user|
    users.each do |second_user|
      if rand < 0.75
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample
        )
      end 

      if rand < 0.75
        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
    end
  end    
  p "#{FollowRequest.count} follows have been created."  

  users.each do |user|
    rand(15).times do
      photo = user.own_photos.create(
        caption: Faker::Quote.jack_handey,
        image: "https://robohash.org/#{rand(9999)}"
      )

      user.followers.each do |follower|
        #if rand < 0.5
        #  photo.fans << follower
        #end

        if rand < 0.5
          photo.comments.create(
          body: Faker::Quote.jack_handey,
          author: follower
          )
        end
      end
    end
  end

  #users.each do |main_user|
  # users.each do |other_user|
  #   if rand < 0.5
  #     other_user.own_photo.likes.create(
  #       fan_id: main_user
  #     )
  #   end  
  # end
  #end  
  #p "#{Like.count} likes have been created." 

ending = Time.now
  p "It took #{(ending - starting).to_i} seconds to create sample data."
  p "There are now #{User.count} users."
  p "There are now #{FollowRequest.count} follow requests."
  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."
end