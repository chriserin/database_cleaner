require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/mongo_spec_helper'
require 'mongo'
require 'database_cleaner/mongo/stump'
require File.dirname(__FILE__) + '/mongo_examples'
require 'active_support/time'

module DatabaseCleaner
  module Mongo

    describe Stump do
      include DatabaseCleaner::MongoSpecHelper

      let(:args) { {} }
      let(:stump) { described_class.new(args).tap { |t| t.db=@db } }
      #doing this in the file root breaks autospec, doing it before(:all) just fails the specs
      before(:each) do
        setup_db
        create_stump_data
      end

      after(:each) do
        teardown_db
      end

      def create_stump_data
        create_widget
        create_gadget
      end

      def start_cleaner
        stump.start
      end

      it "reverts to stump data for all collections by default" do
        start_cleaner
        ensure_counts(MongoTest::Widget => 1, MongoTest::Gadget => 1)
        create_widget :updated_at => Time.now.utc
        create_gadget :updated_at => Time.now.utc
        ensure_counts(MongoTest::Widget => 2, MongoTest::Gadget => 2)
        stump.clean
        ensure_counts(MongoTest::Widget => 1, MongoTest::Gadget => 1)
      end

      context "when collections are provided to the :only option" do
        let(:args) {{:only => ['MongoTest::Widget']}}
        it "only reverts to stump for the specified collections" do
          start_cleaner
          create_widget :updated_at => Time.now
          create_gadget :updated_at => Time.now
          ensure_counts(MongoTest::Widget => 2, MongoTest::Gadget => 2)
          stump.clean
          ensure_counts(MongoTest::Widget => 1, MongoTest::Gadget => 2)
        end
      end

      context "when collections are provided to the :except option" do
        let(:args) {{:except => ['MongoTest::Widget']}}
        it "reverts to stump for all but the specified collections" do
          start_cleaner
          create_widget :updated_at => Time.now
          create_gadget :updated_at => Time.now
          ensure_counts(MongoTest::Widget => 2, MongoTest::Gadget => 2)
          stump.clean
          ensure_counts(MongoTest::Widget => 2, MongoTest::Gadget => 1)
        end
      end
    end
  end
end
