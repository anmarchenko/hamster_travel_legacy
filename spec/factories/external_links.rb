# frozen_string_literal: true

# == Schema Information
#
# Table name: external_links
#
#  id            :integer          not null, primary key
#  description   :string
#  url           :text
#  linkable_id   :integer
#  linkable_type :string
#

FactoryGirl.define do
  factory :external_link do
    url 'http://www.somesite.com'
  end
end
