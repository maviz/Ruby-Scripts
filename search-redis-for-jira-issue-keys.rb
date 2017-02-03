require "redis"
require "byebug"


redis = Redis.new

redis_keys_jira_ids = redis.keys("*-jira-issue-keys")

redis_keys_jira_ids.each do |key|

	puts redis.get(key).split(',')

end

