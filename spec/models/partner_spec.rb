# == Schema Information
#
# Table name: partners
#
#  id                      :integer          not null, primary key
#  body                    :text
#  contact_email           :string
#  contact_name            :string
#  cover_content_type      :string
#  cover_file_name         :string
#  cover_file_size         :integer
#  cover_updated_at        :datetime
#  environment             :text             default("production"), not null
#  featured                :boolean          default(FALSE)
#  icon_content_type       :string
#  icon_file_name          :string
#  icon_file_size          :integer
#  icon_updated_at         :datetime
#  logo_content_type       :string
#  logo_file_name          :string
#  logo_file_size          :integer
#  logo_updated_at         :datetime
#  name                    :string
#  partner_type            :string
#  published               :boolean          default(FALSE)
#  slug                    :string
#  summary                 :string
#  website                 :string
#  white_logo_content_type :string
#  white_logo_file_name    :string
#  white_logo_file_size    :integer
#  white_logo_updated_at   :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_partners_on_slug  (slug)
#

require 'rails_helper'

RSpec.describe Partner, type: :model do
  describe :create do
    context 'environment given' do
      let(:subject) { FactoryBot.create(:partner, environment: 'potato') }

      it 'saves specified environment' do
        expect(subject.environment).to eq('potato')
      end
    end

    context 'environment not given' do
      let(:subject) { FactoryBot.create(:partner, environment: nil) }

      it 'saves production environment' do
        expect(subject.environment).to eq(Environment::PRODUCTION)
      end
    end
  end
end
