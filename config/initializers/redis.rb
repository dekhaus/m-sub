LAST_TIMESTAMP='notification_timestamp_42037933' # some random key

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
REDIS_PUB = PubSubRedis.new(:host => uri.host, :port => uri.port, :password => uri.password)
REDIS_SUB = PubSubRedis.new(:host => uri.host, :port => uri.port, :password => uri.password,
               :timestamp => REDIS.get(LAST_TIMESTAMP).to_f)