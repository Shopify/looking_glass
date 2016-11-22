require 'json'

module LookingGlass
  module Graph
    class Server
      JSON_TYPE = {
        'Content-Type'.freeze => 'application/json'.freeze
      }.freeze

      BATCH_ENDPOINT = '/graphql/batch'.freeze

      def call(env)
        sleep 1

        req = Rack::Request.new(env)
        data = JSON.parse(req.body.read)
        res = if req.path_info == BATCH_ENDPOINT
          data.map { |d| execute(d) }
        else
          execute(data)
        end
        rr = JSON.dump(res)
        if rr.size < 2000
          puts rr
        end
        [200, JSON_TYPE, [JSON.dump(res)]]
      end

      private

      def execute(data)
        q = data['query']
        v = data['variables']
        begin
          Schema.execute(q, variables: v)
        rescue
          puts "ERR ON"
          puts q
          puts v
          raise
        end
      end
    end
  end
end
