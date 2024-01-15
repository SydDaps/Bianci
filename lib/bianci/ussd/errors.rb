# frozen_string_literal: true

module Bianci
  module USSD
    class Error
      attr_accessor :params, :activity_state, :prompt_data, :menu, :page_number, :store, :id, :mobile_number

      def initialize(params, menu = nil, page_number = nil)
        @params = params.with_indifferent_access
        @activity_state = params[:activity_state]
        @mobile_number = params[:mobile_number]
        @id = params[:session_id]
        @input = params[:input]
        @prompt_data = {}
        @menu = menu
        @page_number = page_number
        @store = Bianci::USSD::Store.new(self)
      end
    end
  end
end
