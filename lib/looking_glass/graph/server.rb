require 'json'

module LookingGlass
  module Graph
    class Server
      def call(env)
        req = Rack::Request.new(env)
        query = req.body.read

        [
          200,
          { 'Content-Type' => 'application/json' },
          [JSON.dump(Schema.execute(query))]
        ]
      end
    end
  end
end
