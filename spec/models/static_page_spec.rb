# == Schema Information
#
# Table name: static_pages
#
#  id                 :bigint           not null, primary key
#  content            :text
#  description        :text
#  environment        :text             default("production"), not null
#  photo_content_type :string
#  photo_file_name    :string
#  photo_file_size    :integer
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
    context 'environment given' do
      let(:subject) { FactoryBot.create(:static_page, environment: 'potato') }

      it 'saves specified environment' do
        expect(subject.environment).to eq('potato')
      end
    end

    context 'environment not given' do
      let(:subject) { FactoryBot.create(:static_page, environment: nil) }

      it 'saves production environment' do
        expect(subject.environment).to eq(Environment::PRODUCTION)
      end
    end
  end
end
