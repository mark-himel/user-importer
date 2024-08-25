require 'csv'

module Users
  class CsvImporter
    attr_reader :file_path
    attr_accessor :errors, :success_count, :failed_count

    def initialize(file_path)
      @file_path = file_path
      @errors = []
      @success_count = 0
      @failed_count = 0
    end

    def import
      parse_file
      return unless errors.blank?

      create_users
    end

    private

    def parse_file
      if @file_path.nil?
        errors << I18n.t('users.errors.no_file')
        return
      end

      @rows = CSV.read(file_path, headers: true)
                 .map { |row| row.to_h }
                 .map(&:symbolize_keys)
      errors << I18n.t('users.errors.no_record') if @rows.blank?
    rescue CSV::MalformedCSVError => _e
      errors << I18n.t('users.errors.invalid_format')
    end

    def create_users
      User.transaction do
        @rows.each_with_index do |row, index|
          create_user(row, index)
        end
      end
    end

    def create_user(attributes, index)
      form = Users::CreateForm.new(attributes)
      if form.save
        @success_count += 1
      else
        @failed_count += 1
        form.errors.full_messages.each do |msg|
          errors << I18n.t('users.errors.import_row_failure', row: index + 2, error: msg)
        end
      end
    end
  end
end
