require 'database_cleaner/mongoid/base'
require 'database_cleaner/generic/truncation'
require 'database_cleaner/mongo/truncation_mixin'
require 'database_cleaner/mongo/stump_mixin'
require 'database_cleaner/moped/truncation_base'
require 'database_cleaner/moped/stump_base'
require 'mongoid/version'

module DatabaseCleaner
  module Mongoid
    class Stump
      include ::DatabaseCleaner::Mongoid::Base
      include ::DatabaseCleaner::Generic::Truncation

      if ::Mongoid::VERSION < '3'

        include ::DatabaseCleaner::Mongo::StumpMixin

        private

        def database
          ::Mongoid.database
        end

      else

        include ::DatabaseCleaner::Moped::StumpBase

        private

        def session
          ::Mongoid.default_session
        end

      end

    end
  end
end

