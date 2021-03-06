# frozen_string_literal: true
# == Schema Information
#
# Table name: tools
#
#  id                     :bigint(8)        not null, primary key
#  title                  :string
#  slug                   :string
#  summary                :string
#  description            :string
#  content                :text
#  url                    :string
#  thumbnail_file_name    :string
#  thumbnail_content_type :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  published              :boolean
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  production             :boolean          default(TRUE)
#  preproduction          :boolean          default(FALSE)
#  staging                :boolean          default(FALSE)
#

require 'test_helper'

class ToolTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
