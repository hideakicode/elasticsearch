module Elasticsearch
  module DSL
    module Search
      module Filters

        # A compound filter which matches documents based on combinations of filters
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             bool do
        #               must do
        #                 term category: 'men'
        #                 term size:  'xxl'
        #               end
        #
        #               should do
        #                 term color: 'red'
        #               end
        #
        #               must_not do
        #                 term manufacturer: 'evil'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a working example.
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-bool-filter.html
        #
        class Bool
          include BaseComponent

          def must(*args, &block)
            @hash[name][:must] ||= []
            @hash[name][:must].push(Filter.new(*args, &block).to_hash).flatten!
            self
          end

          def must_not(*args, &block)
            @hash[name][:must_not] ||= []
            @hash[name][:must_not].push(Filter.new(*args, &block).to_hash).flatten!
            self
          end

          def should(*args, &block)
            @hash[name][:should] ||= []
            @hash[name][:should].push(Filter.new(*args, &block).to_hash).flatten!
            self
          end

          def to_hash
            @hash[name].update(@args.to_hash) if @args.respond_to?(:to_hash)

            if @block
              @block.arity < 1 ? self.instance_eval(&@block) : @block.call(self)
            else
              @hash[name] = @args unless @args.nil? || @args.empty?
            end

            @hash
          end
        end

      end
    end
  end
end
