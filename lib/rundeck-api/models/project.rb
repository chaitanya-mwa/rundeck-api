#
#   Author: Rohith
#   Date: 2014-06-20 11:45:32 +0100 (Fri, 20 Jun 2014)
#
#  vim:ts=2:sw=2:et
#
require 'job'

module Rundeck
  module Models
    class Project
      attr_reader :name, :description

      def initialize session, definition
        @session = session
        parse_definition definition
      end

      def jobs &block
        @session.get( "/api/1/jobs/export?project=#{@name}" )['job'].map do |x|
          job = Rundeck::Models::Job.new @session, x          
          yield job if block_given?
          job 
        end
      end

      def job name 
        the_job = jobs.select { |x| x.name == name }.first
        raise ArgumentError, "the job: #{name} does not exist in this project" unless the_job
        the_job
      end

      def job? name 
        !job.nil?
      end
      
      private 
      def parse_definition definition
        @name = definition['name'].first
        @description = definition['description'].first
      end
    end
  end
end