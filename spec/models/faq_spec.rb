# == Schema Information
#
# Table name: faqs
#
#  id         :bigint           not null, primary key
#  answer     :text             not null
#  env        :text             default("production"), not null
#  order      :integer
#  question   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Faq, type: :model do
  describe :create do
    context 'env given' do
      let(:subject) { FactoryBot.create(:faq, env: 'potato') }

      it 'saves specified env' do
        expect(subject.env).to eq('potato')
      end
    end

    context 'env not given' do
      let(:subject) { FactoryBot.create(:faq, env: nil) }

      it 'saves production env' do
        expect(subject.env).to eq(Environment::PRODUCTION)
      end
    end
  end
end
