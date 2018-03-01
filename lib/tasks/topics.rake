namespace :topics do
  desc 'Duplicates the current dashboards to topics'
  task copy_from_dashboards: :environment do
    Dashboard.find_each do |dashboard|
      topic = Topic.new
      topic.name = dashboard.name
      topic.slug = dashboard.slug
      topic.description = dashboard.description
      topic.content = dashboard.content
      topic.published = dashboard.published
      topic.summary = dashboard.summary
      topic.private = dashboard.private
      topic.user_id = dashboard.user_id
      topic.photo = dashboard.photo
      topic.save
    end
  end
end