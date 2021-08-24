# == Schema Information
#
# Table name: dashboards
#
#  id                        :bigint           not null, primary key
#  application               :string           default(["\"rw\""]), not null, is an Array
#  author_image_content_type :string
#  author_image_file_name    :string
#  author_image_file_size    :integer
#  author_image_updated_at   :datetime
#  author_title              :string           default("")
#  content                   :text
#  description               :string
#  env                       :text             default("production"), not null
#  is_featured               :boolean          default(FALSE)
#  is_highlighted            :boolean          default(FALSE)
#  name                      :string
#  photo_content_type        :string
#  photo_file_name           :string
#  photo_file_size           :integer
#  photo_updated_at          :datetime
#  private                   :boolean          default(TRUE)
#  published                 :boolean
#  slug                      :string
#  summary                   :string
#  user_name                 :string
#  user_role                 :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  user_id                   :string
#

require 'rails_helper'

RSpec.describe Dashboard, type: :model do
  describe :create do
    context 'env given' do
      let(:subject) { FactoryBot.create(:dashboard, env: 'potato') }

      it 'saves specified env' do
        expect(subject.env).to eq('potato')
      end
    end

    context 'env not given' do
      let(:subject) { FactoryBot.create(:dashboard, env: nil) }

      it 'saves production env' do
        expect(subject.env).to eq(Environment::PRODUCTION)
      end
    end
  end
end
