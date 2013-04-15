Dir["#{Rails.root}/app/jobs/*.rb"].each { |file| require file }
Resque.redis = REDIS
Resque.enqueue(Subscribe)