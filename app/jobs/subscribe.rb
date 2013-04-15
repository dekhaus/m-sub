class Subscribe
  @queue = :subscribe

  def self.perform()
    
    puts "subscribing to *.* ..."
    
    REDIS_SUB.backlog(['*.*']) do |channel, message|
      self.send(message["action"], message)
    end
    REDIS_SUB.psubscribe('*.*') do |on|
      on.psubscribe do |channel, subscriptions|
        Rails.logger.info("Subscribed to ##{channel} (#{subscriptions} subscriptions)")
      end

      on.pmessage do |pattern, channel, message|

        puts "pattern = #{pattern}, channel = #{channel}, message = #{message.inspect}"

        REDIS_PUB.set(LAST_TIMESTAMP, Time.now.to_f)
        message = MultiJson.decode(message)
        self.send(message["action"], message)
        redis.unsubscribe if message == "exit"
      end

      on.punsubscribe do |channel, subscriptions|
        Rails.logger.info("Unsubscribed from ##{channel} (#{subscriptions} subscriptions)")
      end
    end
  end
  
  def self.create(message)
    if message['klass'] == 'product'
      Product.create(:name => message["name"])
    elsif message['klass'] == 'category'
      Category.create(:name => message["name"])
    end
  end
  
  def self.update(message)
    if message['klass'] == 'product'
      obj = Product.find(message["product"])
    elsif message['klass'] == 'category'
      obj = Category.find(message["category"])
    end
    puts obj if obj
    puts "ERROR::Couldn't find obj (#{obj.inspect})" if obj.nil?
    
    obj.update_attributes(:name => message["new_name"])
  end
  
  def self.destroy(message)
    if message['klass'] == 'product'
      Product.find(message["product"]).destroy
    elsif message['klass'] == 'category'
      Category.find(message["category"]).destroy
    end
  end
end

