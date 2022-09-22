# == Schema Information
#
# Table name: static_pages
#
#  id                 :bigint           not null, primary key
#  content            :text
#  description        :text
#  env                :text             default("production"), not null
#  photo_content_type :string
#  photo_file_name    :string
#  photo_file_size    :bigint
#  photo_updated_at   :datetime
#  published          :boolean
#  slug               :string
#  summary            :text
#  title              :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_static_pages_on_slug  (slug)
#

require 'rails_helper'

RSpec.describe StaticPage, type: :model do
  describe :create do
    context 'env given' do
      let(:subject) { FactoryBot.create(:static_page, env: 'potato') }

      it 'saves specified env' do
        expect(subject.env).to eq('potato')
      end
    end

    context 'env not given' do
      let(:subject) { FactoryBot.create(:static_page, env: nil) }

      it 'saves production env' do
        expect(subject.env).to eq(Environment::PRODUCTION)
      end
    end
  end
end
