# typed: false

require 'rails_helper'

describe Users::CsvImporter do
  let(:service_instance) { described_class.new(path&.to_s) }
  let(:path) { Rails.root.join('spec/support/files/users.csv') }

  it 'creates a user successfully' do
    expect { service_instance.import }.to change(User, :count).from(0).to(1)
    expect(User.first.name).to eq('Muhammad')
  end

  it 'stores information of the import result' do
    service_instance.import
    expect(service_instance.success_count).to eq(1)
    expect(service_instance.failed_count).to eq(3)
    expect(service_instance.errors).to match_array(
     [
       'Row 3 failed to import because Password is invalid',
       'Row 4 failed to import because Password is too short (minimum is 10 characters)',
       'Row 5 failed to import because Password is invalid'
     ])
  end

  context 'with no file provided' do
    let(:path) { nil }

    it 'fails to import and stores the error message' do
      service_instance.import
      expect(service_instance.errors).to contain_exactly 'No file provided'
    end
  end

  context 'with empty file' do
    let(:path) { Rails.root.join('spec/support/files/empty.csv') }

    it 'fails to import and stores the error message' do
      service_instance.import
      expect(service_instance.errors).to contain_exactly 'No record found'
    end
  end
end
