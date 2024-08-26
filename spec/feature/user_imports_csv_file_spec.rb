require 'rails_helper'

describe 'user imports csv file', type: :feature do
  before do
    visit root_path
  end

  context 'user importing a valid csv file' do
    it 'visits import page and imports a csv successfully' do
      expect(page).to have_content('Users')
      expect(User.count).to eq(0)
      attach_file('users_file', Rails.root.join('spec/support/files/users.csv').to_s)
      click_on 'Import'
      expect(page).to have_content('1 rows were successfully imported!')
      expect(page).to have_content('3 rows were failed to import.')
      expect(page).to have_content('Row 3 failed to import because Password is invalid')
      expect(page).to have_content('Row 4 failed to import because Password is too short (minimum is 10 characters)')
      expect(page).to have_content('Row 5 failed to import because Password is invalid')
      expect(User.count).to eq(1)
      expect(User.last.name).to eq('Muhammad')
    end
  end

  context 'user importing an empty csv file' do
    it 'returns a proper error message' do
      attach_file('users_file', Rails.root.join('spec/support/files/empty.csv').to_s)
      click_on 'Import'
      expect(page).to have_content('No record found')
      expect(User.count).to eq(0)
    end
  end

  context 'user importing a csv file with invalid headers' do
    it 'returns a proper error message' do
      attach_file('users_file', Rails.root.join('spec/support/files/invalid_columns.csv').to_s)
      click_on 'Import'
      expect(page).to have_content('Wrong headers. Valid headers are ["name", "password"]')
      expect(User.count).to eq(0)
    end
  end
end
