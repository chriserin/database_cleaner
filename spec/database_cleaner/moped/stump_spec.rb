require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/../mongo/mongo_spec_helper'
require 'moped'
require 'database_cleaner/moped/stump'
require File.dirname(__FILE__) + '/moped_examples'
require 'active_support/time'

module DatabaseCleaner
  module Moped

    describe Stump do
      include DatabaseCleaner::MongoSpecHelper
      let(:args) {{}}
      let(:stump) { described_class.new(args).tap { |t| t.db=@db } }
      #doing this in the file root breaks autospec, doing it before(:all) just fails the specs
      before(:all) do
        @test_db = 'database_cleaner_specs'
        @session = ::Moped::Session.new(['127.0.0.1:27017'], database: @test_db)
      end

      before(:each) do
        stump.db = @test_db
        create_stump_data
        stump.start
      end

      after(:each) do
        @session.drop
      end

      def create_stump_data
        create_widget
        create_gadget
      end

      def create_widget(attrs={})
        MopedTest::Widget.new({:name => 'some widget'}.merge(attrs)).save!
      end

      def create_gadget(attrs={})
        MopedTest::Gadget.new({:name => 'some gadget'}.merge(attrs)).save!
      end

      it "truncates all collections by default" do
        create_widget :updated_at => Time.now
        create_gadget :updated_at => Time.now
        ensure_counts(MopedTest::Widget => 2, MopedTest::Gadget => 2)
        stump.clean
        ensure_counts(MopedTest::Widget => 1, MopedTest::Gadget => 1)
      end

      context "when collections are provided to the :only option" do
        let(:args) {{:only => ['MopedTest::Widget']}}
        it "only truncates the specified collections" do
          create_widget :updated_at => Time.now
          create_gadget :updated_at => Time.now
          ensure_counts(MopedTest::Widget => 2, MopedTest::Gadget => 2)
          stump.clean
          ensure_counts(MopedTest::Widget => 1, MopedTest::Gadget => 2)
        end
      end

      context "when collections are provided to the :except option" do
        let(:args) {{:except => ['MopedTest::Widget']}}
        it "truncates all but the specified collections" do
          create_widget :updated_at => Time.now
          create_gadget :updated_at => Time.now
          ensure_counts(MopedTest::Widget => 2, MopedTest::Gadget => 2)
          stump.clean
          ensure_counts(MopedTest::Widget => 2, MopedTest::Gadget => 1)
        end
      end
    end
  end
end
