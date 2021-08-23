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
