# == Schema Information
#
# Table name: dashboards
#
#  id          :integer          not null, primary key
#  name        :string
#  slug        :string
#  description :string
#  content     :text
#  published   :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  summary     :string
#  photo       :string
#

require 'test_helper'

class DashboardTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
