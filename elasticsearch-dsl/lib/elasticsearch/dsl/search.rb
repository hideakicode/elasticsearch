module Elasticsearch
  module DSL

    # Provides DSL methods for building the search definition
    # (queries, filters, aggregations, sorting, etc)
    #
    module Search

      # Initialize a new Search object
      #
      # @example Building a search definition declaratively
      #
      #     definition = search do
      #       query do
      #         match title: 'test'
      #       end
      #     end
      #
      # @example Using the class imperatively
      #
      #     definition = Search.new
      #     query = Query.new
      #     definition.query query
      #     definition.to_hash
      #     # => => {:query=>{:match=>{:title=>"Test"}}}
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search.html
      #
      def search(*args, &block)
        Search.new(*args, &block)
      end

      # Wraps the whole search definition (queries, filters, aggregations, sorting, etc)
      #
      class Search
        attr_reader :aggregations

        def initialize(*args, &block)
          @options = Options.new
          instance_eval(&block) if block
        end

        # DSL method for building the `query` part of a search definition
        #
        # @return [self]
        #
        def query(*args, &block)
          if block
            @query = Query.new(*args, &block)
          else
            @query = args.first
          end
          self
        end

        # DSL method for building the `filter` part of a search definition
        #
        # @return [self]
        #
        def filter(*args, &block)
          if block
            @filter = Filter.new(*args, &block)
          else
            @filter = args.first
          end
          self
        end

        # DSL method for building the `post_filter` part of a search definition
        #
        # @return [self]
        #
        def post_filter(*args, &block)
          if block
            @post_filter = Filter.new(*args, &block)
          else
            @post_filter = args.first
          end
          self
        end

        # DSL method for building the `aggregations` part of a search definition
        #
        # @return [self]
        #
        def aggregation(*args, &block)
          @aggregations ||= {}

          if block
            @aggregations.update args.first => Aggregation.new(*args, &block)
          else
            name = args.shift
            @aggregations.update name => args.shift
          end
          self
        end

        # DSL method for building the `sort` part of a search definition
        #
        # @return [self]
        #
        def sort(*args, &block)
          @sort = Sort.new(*args, &block)
          self
        end

        # DSL method for building the `size` part of a search definition
        #
        # @return [self]
        #
        def size(value)
          @size = value
          self
        end

        # DSL method for building the `from` part of a search definition
        #
        # @return [self]
        #
        def from(value)
          @from = value
          self
        end

        # DSL method for building the `suggest` part of a search definition
        #
        # @return [self]
        #
        def suggest(*args, &block)
          @suggest ||= {}
          key, options = args
          @suggest.update key => Suggest.new(key, options, &block)
          self
        end

        # Delegates to the methods provided by the {Options} class
        #
        def method_missing(name, *args, &block)
          if @options.respond_to? name
            @options.__send__ name, *args, &block
            self
          else
            super
          end
        end

        # Converts the search definition to a Hash
        #
        # @return [Hash]
        #
        def to_hash
          hash = {}
          hash.update(query: @query.to_hash)   if @query
          hash.update(filter: @filter.to_hash) if @filter
          hash.update(post_filter: @post_filter.to_hash) if @post_filter
          hash.update(aggregations: @aggregations.reduce({}) { |sum,item| sum.merge item.first => item.last.to_hash }) if @aggregations
          hash.update(sort: @sort.to_hash) if @sort
          hash.update(size: @size) if @size
          hash.update(from: @from) if @from
          hash.update(suggest: @suggest.reduce({}) { |sum,item| sum.merge item.last.to_hash }) if @suggest
          hash.update(@options) unless @options.empty?
          hash
        end
      end
    end
  end
end