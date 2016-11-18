require 'json'

module LookingGlass
  module Graph
    class Server
      def call(env)
        req       = Rack::Request.new(env)
        data      = JSON.parse(req.body.read)
        query     = data['query']
        variables = data['variables']

        puts query
        puts variables.inspect

        res = JSON.pretty_generate(Schema.execute(query, variables: variables))
        puts res if res.size < 9000
        [
          200,
          { 'Content-Type' => 'application/json' },
          [res]
        ]
      end
    end
  end
end
