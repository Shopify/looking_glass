require 'json'

require 'looking_glass'

module LookingGlass
  class Server
    JSON_TYPE = {
      'Content-Type'.freeze => 'application/json'.freeze
    }.freeze

    def call(env)
      puts "<- #{Time.now}"
      req  = Rack::Request.new(env)
      data = JSON.parse(req.body.read)
      q    = data['query']
      v    = data['variables']
      res  = Schema.execute(q, variables: v)
      puts "-> #{Time.now}"

      [200, JSON_TYPE, [JSON.dump(res)]]
    end
  end
end
