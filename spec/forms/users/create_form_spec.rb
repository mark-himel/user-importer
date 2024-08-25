require 'rails_helper'

describe Users::CreateForm do
  subject(:form) { described_class.new(form_params) }
  let(:form_params) do
    { name: 'John', password: 'Aqpfk1swods' }
  end

  context 'when all params are valid' do
    it 'successfully creates the user record' do
      expect { form.save }.to change(User, :count)
    end
  end

  describe 'Invalid params' do
    context 'when name is blank' do
      before { form_params.merge!(name: '') }

      it 'fails to create the user record' do
        expect { form.save }.not_to change(User, :count)
        expect(form.errors.full_messages).to eq(["Name can't be blank"])
      end
    end

    context 'when name is empty' do
      before { form_params.merge!(name: nil) }

      it 'fails to create the user record' do
        expect { form.save }.not_to change(User, :count)
        expect(form.errors.full_messages).to eq(["Name can't be blank"])
      end
    end

    context 'when password is blank' do
      before { form_params.merge!(password: '') }

      it 'fails to create the user record' do
        expect { form.save }.not_to change(User, :count)
        expect(form.errors.full_messages).to include("Password can't be blank")
      end
    end

    context 'when password is missing a digit and a capital letter' do
      before { form_params.merge!(password: 'abcdefghijklmnop') }

      it 'fails to create the user record' do
        expect { form.save }.not_to change(User, :count)
        expect(form.errors.full_messages).not_to include("Password can't be blank")
        expect(form.errors.full_messages).to include('Password is invalid')
      end
    end

    context 'when password is too short' do
      before { form_params.merge!(password: 'Abc123') }

      it 'fails to create the user record' do
        expect { form.save }.not_to change(User, :count)
        expect(form.errors.full_messages).to include('Password is too short (minimum is 10 characters)')
      end
    end

    context 'when password has a character repeating more than twice in a row' do
      before { form_params.merge!(password: 'AAAfk1swods') }

      it 'fails to create the user record' do
        expect { form.save }.not_to change(User, :count)
        expect(form.errors.full_messages).to include('Password is invalid')
      end
    end
  end
end
