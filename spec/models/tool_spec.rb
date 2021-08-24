# == Schema Information
#
# Table name: tools
#
#  id                     :bigint           not null, primary key
#  content                :text
#  description            :string
#  env                    :text             default("production"), not null
#  published              :boolean
#  slug                   :string
#  summary                :string
#  thumbnail_content_type :string
#  thumbnail_file_name    :string
#  thumbnail_file_size    :integer
#  thumbnail_updated_at   :datetime
#  title                  :string
#  url                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

RSpec.describe Tool, type: :model do
  describe :create do
    context 'env given' do
      let(:subject) { FactoryBot.create(:tool, env: 'potato') }

      it 'saves specified env' do
        expect(subject.env).to eq('potato')
      end
    end

    context 'env not given' do
      let(:subject) { FactoryBot.create(:tool, env: nil) }

      it 'saves production env' do
        expect(subject.env).to eq(Environment::PRODUCTION)
      end
    end
  end
end
