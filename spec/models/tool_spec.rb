# == Schema Information
#
# Table name: tools
#
#  id                     :bigint           not null, primary key
#  content                :text
#  description            :string
#  environment            :text             default("production"), not null
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
    context 'environment given' do
      let(:subject) { FactoryBot.create(:tool, environment: 'potato') }

      it 'saves specified environment' do
        expect(subject.environment).to eq('potato')
      end
    end

    context 'environment not given' do
      let(:subject) { FactoryBot.create(:tool, environment: nil) }

      it 'saves production environment' do
        expect(subject.environment).to eq(Environment::PRODUCTION)
      end
    end
  end
end
