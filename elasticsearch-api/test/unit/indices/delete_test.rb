require 'test_helper'

module Elasticsearch
  module Test
    class IndicesDeleteTest < ::Test::Unit::TestCase

      context "Indices: Delete" do
        subject { FakeClient.new(nil) }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'DELETE', method
            assert_equal 'foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.indices.delete :index => 'foo'
        end

        should "perform the request for more indices" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo,bar', url
            true
          end.returns(FakeResponse.new)

          subject.indices.delete :index => ['foo','bar']
        end

        should "pass the URL parameters" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'foo', url
            assert_equal '1s', params[:timeout]
            true
          end.returns(FakeResponse.new)

          subject.indices.delete :index => 'foo', :timeout => '1s'
        end

      end

    end
  end
end
