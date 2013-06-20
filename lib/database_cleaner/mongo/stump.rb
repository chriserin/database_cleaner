require 'database_cleaner/mongo/base'
require 'database_cleaner/mongo/stump_mixin'
require 'database_cleaner/generic/truncation'

module DatabaseCleaner
  module Mongo
    class Stump
      include ::DatabaseCleaner::Generic::Truncation
      include StumpMixin
      include Base

      def database
        db
      end
    end
  end
end
