class UsersController < ApplicationController
  def index ;end

  def import
    importer = Users::CsvImporter.new(import_params[:file])
    importer.import
    streams = [
      turbo_stream.replace('success-info', partial: 'success_info', locals: { count: importer.success_count }),
      turbo_stream.replace(
        'failed-info',
        partial: 'failed_info',
        locals: { count: importer.failed_count, errors: importer.errors }
      )
    ]
    render turbo_stream: streams
  end

  private

  def import_params
    params.require(:users).permit(:file)
  end
end
