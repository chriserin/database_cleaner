require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/mongo_spec_helper'
require 'mongo'
require 'database_cleaner/mongo/truncation'
require File.dirname(__FILE__) + '/mongo_examples'

module DatabaseCleaner
  module Mongo

    describe Truncation do
      include DatabaseCleaner::MongoSpecHelper

      let(:args) {{}}
      let(:truncation) { described_class.new(args).tap { |t| t.db=@db } }
      #doing this in the file root breaks autospec, doing it before(:all) just fails the specs
      before(:all) do
        setup_db
      end

      after(:each) do
        teardown_db
      end

      it "truncates all collections by default" do
        create_widget
        create_gadget
        ensure_counts(MongoTest::Widget => 1, MongoTest::Gadget => 1)
        truncation.clean
        ensure_counts(MongoTest::Widget => 0, MongoTest::Gadget => 0)
      end

      context "when collections are provided to the :only option" do
        let(:args) {p "set args"; {:only => ['MongoTest::Widget']}}
        let(:x) { p "set x"; "x"}
        it "only truncates the specified collections" do
          x
          create_widget
          create_gadget
          ensure_counts(MongoTest::Widget => 1, MongoTest::Gadget => 1)
          truncation.clean
          ensure_counts(MongoTest::Widget => 0, MongoTest::Gadget => 1)
        end
      end

      context "when collections are provided to the :except option" do
        let(:args) {{:except => ['MongoTest::Widget']}}
        it "truncates all but the specified collections" do
          create_widget
          create_gadget
          ensure_counts(MongoTest::Widget => 1, MongoTest::Gadget => 1)
          truncation.clean
          ensure_counts(MongoTest::Widget => 1, MongoTest::Gadget => 0)
        end
      end
    end
  end
end
