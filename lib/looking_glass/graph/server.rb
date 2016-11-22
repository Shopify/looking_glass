require 'json'

module LookingGlass
  module Graph
    class Server
      JSON_TYPE = {
        'Content-Type'.freeze => 'application/json'.freeze
      }.freeze

      def call(env)
        req  = Rack::Request.new(env)
        data = JSON.parse(req.body.read)
        q    = data['query']
        v    = data['variables']
        res  = Schema.execute(q, variables: v)

        [200, JSON_TYPE, [JSON.dump(res)]]
      end
    end
  end
end
