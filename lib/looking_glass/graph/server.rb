require 'json'

module LookingGlass
  module Graph
    class Server
      def call(env)
        req       = Rack::Request.new(env)
        data      = JSON.parse(req.body.read)
        query     = data['query']
        variables = data['variables']

        debug = ENV.has_key?('DEBUG')

        puts query if debug
        puts variables.inspect if debug

        res = JSON.pretty_generate(Schema.execute(query, variables: variables))
        puts res if debug && res.size < 9000
        [
          200,
          { 'Content-Type' => 'application/json' },
          [res]
        ]
      end
    end
  end
end
